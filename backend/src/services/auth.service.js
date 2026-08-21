import bcrypt from 'bcryptjs';
import crypto from 'crypto';
import jwt from 'jsonwebtoken';
import { env } from '../config/env.js';
import { query } from '../db/pool.js';
import { createOtpForUser, maskEmail, maskPhone, verifyOtp } from './otp.service.js';

function sanitizeUser(row) {
  if (!row) return null;
  return {
    id: row.id,
    name: row.name,
    email: row.email,
    phone: row.phone,
    isVerified: Boolean(row.is_verified),
    createdAt: row.created_at,
  };
}

function signAccessToken(user) {
  return jwt.sign(
    { sub: user.id, email: user.email, name: user.name },
    env.jwt.accessSecret,
    { expiresIn: env.jwt.accessExpiresIn },
  );
}

async function createRefreshToken(userId) {
  const raw = crypto.randomBytes(48).toString('hex');
  const tokenHash = await bcrypt.hash(raw, 10);
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);

  await query(
    `INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (:userId, :tokenHash, :expiresAt)`,
    { userId, tokenHash, expiresAt },
  );

  return jwt.sign({ sub: userId, token: raw }, env.jwt.refreshSecret, {
    expiresIn: env.jwt.refreshExpiresIn,
  });
}

export async function registerUser({ name, email, phone, password }) {
  if (!name?.trim()) {
    const err = new Error('Name is required.');
    err.status = 400;
    throw err;
  }
  if (!email?.trim() && !phone?.trim()) {
    const err = new Error('Email or phone is required.');
    err.status = 400;
    throw err;
  }
  if (!password || password.length < 6) {
    const err = new Error('Password must be at least 6 characters.');
    err.status = 400;
    throw err;
  }

  const passwordHash = await bcrypt.hash(password, 12);

  try {
    const result = await query(
      `INSERT INTO users (name, email, phone, password_hash) VALUES (:name, :email, :phone, :passwordHash)`,
      {
        name: name.trim(),
        email: email?.trim() || null,
        phone: phone?.trim() || null,
        passwordHash,
      },
    );

    const userId = result.insertId;
    const otp = await createOtpForUser(userId, email ? 'email' : 'phone');

    return {
      userId,
      maskedEmail: otp.maskedEmail || maskEmail(email),
      maskedPhone: otp.maskedPhone || maskPhone(phone),
      requiresOtp: true,
    };
  } catch (e) {
    if (e.code === 'ER_DUP_ENTRY') {
      const err = new Error('An account with this email or phone already exists.');
      err.status = 409;
      throw err;
    }
    throw e;
  }
}

export async function loginUser({ identifier, password }) {
  if (!identifier?.trim() || !password) {
    const err = new Error('Email/phone and password are required.');
    err.status = 400;
    throw err;
  }

  const id = identifier.trim();
  const rows = await query(
    `SELECT * FROM users WHERE email = :id OR phone = :id LIMIT 1`,
    { id },
  );
  const user = rows[0];

  if (!user) {
    const err = new Error('Invalid credentials.');
    err.status = 401;
    throw err;
  }

  const valid = await bcrypt.compare(password, user.password_hash);
  if (!valid) {
    const err = new Error('Invalid credentials.');
    err.status = 401;
    throw err;
  }

  const channel = user.email ? 'email' : 'phone';
  const otp = await createOtpForUser(user.id, channel);

  return {
    userId: user.id,
    maskedEmail: otp.maskedEmail || maskEmail(user.email),
    maskedPhone: otp.maskedPhone || maskPhone(user.phone),
    requiresOtp: true,
  };
}

export async function verifyUserOtp({ userId, code, channel }) {
  await verifyOtp(userId, code, channel);

  const rows = await query(`SELECT * FROM users WHERE id = :userId LIMIT 1`, { userId });
  const user = sanitizeUser(rows[0]);
  const accessToken = signAccessToken(user);
  const refreshToken = await createRefreshToken(userId);

  return { accessToken, refreshToken, user };
}

export async function resendUserOtp({ userId, channel }) {
  const rows = await query(`SELECT email, phone FROM users WHERE id = :userId LIMIT 1`, { userId });
  const user = rows[0];
  if (!user) {
    const err = new Error('User not found.');
    err.status = 404;
    throw err;
  }

  if (channel === 'email' && !user.email) {
    const err = new Error('No email on file for this account.');
    err.status = 400;
    throw err;
  }
  if (channel === 'phone' && !user.phone) {
    const err = new Error('No phone on file for this account.');
    err.status = 400;
    throw err;
  }

  const otp = await createOtpForUser(userId, channel);
  return {
    maskedEmail: otp.maskedEmail,
    maskedPhone: otp.maskedPhone,
  };
}

export async function refreshAccessToken(refreshToken) {
  let payload;
  try {
    payload = jwt.verify(refreshToken, env.jwt.refreshSecret);
  } catch {
    const err = new Error('Invalid refresh token.');
    err.status = 401;
    throw err;
  }

  const rows = await query(
    `SELECT id, token_hash, expires_at, revoked_at FROM refresh_tokens
     WHERE user_id = :userId ORDER BY created_at DESC LIMIT 20`,
    { userId: payload.sub },
  );

  let matched = null;
  for (const row of rows) {
    if (row.revoked_at) continue;
    if (new Date(row.expires_at) < new Date()) continue;
    const ok = await bcrypt.compare(payload.token, row.token_hash);
    if (ok) {
      matched = row;
      break;
    }
  }

  if (!matched) {
    const err = new Error('Refresh token revoked or expired.');
    err.status = 401;
    throw err;
  }

  const userRows = await query(`SELECT * FROM users WHERE id = :userId LIMIT 1`, {
    userId: payload.sub,
  });
  const user = sanitizeUser(userRows[0]);
  return { accessToken: signAccessToken(user), user };
}

export async function getUserById(userId) {
  const rows = await query(`SELECT * FROM users WHERE id = :userId LIMIT 1`, { userId });
  return sanitizeUser(rows[0]);
}

export async function logoutUser(userId) {
  await query(
    `UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = :userId AND revoked_at IS NULL`,
    { userId },
  );
}
