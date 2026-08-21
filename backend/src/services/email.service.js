import nodemailer from 'nodemailer';
import { env } from '../config/env.js';

let transporter = null;

function getTransporter() {
  if (!env.smtp.host) return null;
  if (!transporter) {
    transporter = nodemailer.createTransport({
      host: env.smtp.host,
      port: env.smtp.port,
      secure: env.smtp.port === 465,
      auth: env.smtp.user ? { user: env.smtp.user, pass: env.smtp.pass } : undefined,
    });
  }
  return transporter;
}

export async function sendOtpEmail(to, code) {
  const transport = getTransporter();
  if (!transport) {
    console.log(`[DEV OTP] Email to ${to}: ${code}`);
    return;
  }

  await transport.sendMail({
    from: env.smtp.from,
    to,
    subject: 'Grozzby Verification Code',
    text: `Your Grozzby verification code is: ${code}. It expires in 10 minutes.`,
    html: `<p>Your Grozzby verification code is: <strong>${code}</strong></p><p>It expires in 10 minutes.</p>`,
  });
}

export async function sendOtpSms(phone, code) {
  console.log(`[DEV OTP] SMS to ${phone}: ${code}`);
}
