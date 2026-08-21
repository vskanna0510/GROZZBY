import bcrypt from 'bcryptjs';
import crypto from 'crypto';
import { query } from '../db/pool.js';
import { sendOtpEmail, sendOtpSms } from './email.service.js';

const OTP_EXPIRY_MINUTES = 10;

export function maskEmail(email) {
  if (!email) return '';
  const [local, domain] = email.split('@');
  if (!domain) return email;
  const visible = local.slice(0, Math.min(4, local.length));
  return `${visible}${'*'.repeat(Math.max(0, local.length - visible.length))}@${domain}`;
}

export function maskPhone(phone) {
  if (!phone || phone.length < 4) return phone || '';
  return `${phone.slice(0, 2)}${'*'.repeat(phone.length - 4)}${phone.slice(-2)}`;
}

function generateOtpCode() {
  return String(crypto.randomInt(100000, 999999));
}

export async function createOtpForUser(userId, channel) {
  const code = generateOtpCode();
  const codeHash = await bcrypt.hash(code, 10);
  const expiresAt = new Date(Date.now() + OTP_EXPIRY_MINUTES * 60 * 1000);

  await query(
    `UPDATE otp_verifications SET consumed_at = NOW()
     WHERE user_id = :userId AND consumed_at IS NULL`,
    { userId },
  );

  await query(
    `INSERT INTO otp_verifications (user_id, code_hash, channel, expires_at)
     VALUES (:userId, :codeHash, :channel, :expiresAt)`,
    { userId, codeHash, channel, expiresAt },
  );

  const [user] = await query(
    `SELECT email, phone FROM users WHERE id = :userId LIMIT 1`,
    { userId },
  );

  if (channel === 'phone' && user?.phone) {
    await sendOtpSms(user.phone, code);
  } else if (user?.email) {
    await sendOtpEmail(user.email, code);
  }

  return { code, maskedEmail: maskEmail(user?.email), maskedPhone: maskPhone(user?.phone) };
}

export async function verifyOtp(userId, code, channel) {
  const rows = await query(
    `SELECT id, code_hash, expires_at, consumed_at
     FROM otp_verifications
     WHERE user_id = :userId AND channel = :channel AND consumed_at IS NULL
     ORDER BY created_at DESC LIMIT 1`,
    { userId, channel },
  );

  const otp = rows[0];
  if (!otp) {
    const err = new Error('No active verification code found.');
    err.status = 400;
    throw err;
  }

  if (new Date(otp.expires_at) < new Date()) {
    const err = new Error('Verification code has expired.');
    err.status = 400;
    throw err;
  }

  const valid = await bcrypt.compare(code, otp.code_hash);
  if (!valid) {
    const err = new Error('Invalid verification code.');
    err.status = 400;
    throw err;
  }

  await query(`UPDATE otp_verifications SET consumed_at = NOW() WHERE id = :id`, { id: otp.id });
  await query(`UPDATE users SET is_verified = 1 WHERE id = :userId`, { userId });

  return true;
}
