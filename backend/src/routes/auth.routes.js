import { Router } from 'express';
import {
  login,
  logoutHandler,
  meHandler,
  refreshHandler,
  register,
  resendOtpHandler,
  verifyOtpHandler,
} from '../controllers/auth.controller.js';
import { authMiddleware } from '../middleware/auth.middleware.js';

const router = Router();

router.post('/register', register);
router.post('/login', login);
router.post('/verify-otp', verifyOtpHandler);
router.post('/resend-otp', resendOtpHandler);
router.post('/refresh', refreshHandler);
router.get('/me', authMiddleware, meHandler);
router.post('/logout', authMiddleware, logoutHandler);

export default router;
