import {
  getUserById,
  loginUser,
  logoutUser,
  refreshAccessToken,
  registerUser,
  resendUserOtp,
  verifyUserOtp,
} from '../services/auth.service.js';

export async function register(req, res, next) {
  try {
    const result = await registerUser(req.body);
    res.status(201).json(result);
  } catch (e) {
    next(e);
  }
}

export async function login(req, res, next) {
  try {
    const result = await loginUser(req.body);
    res.json(result);
  } catch (e) {
    next(e);
  }
}

export async function verifyOtpHandler(req, res, next) {
  try {
    const { userId, code, channel = 'email' } = req.body;
    const result = await verifyUserOtp({ userId, code, channel });
    res.json(result);
  } catch (e) {
    next(e);
  }
}

export async function resendOtpHandler(req, res, next) {
  try {
    const { userId, channel = 'email' } = req.body;
    const result = await resendUserOtp({ userId, channel });
    res.json(result);
  } catch (e) {
    next(e);
  }
}

export async function refreshHandler(req, res, next) {
  try {
    const { refreshToken } = req.body;
    const result = await refreshAccessToken(refreshToken);
    res.json(result);
  } catch (e) {
    next(e);
  }
}

export async function meHandler(req, res, next) {
  try {
    const user = await getUserById(req.user.id);
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json({ user });
  } catch (e) {
    next(e);
  }
}

export async function logoutHandler(req, res, next) {
  try {
    await logoutUser(req.user.id);
    res.json({ success: true });
  } catch (e) {
    next(e);
  }
}
