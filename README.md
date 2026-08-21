# Grozzby

Monorepo for the Grozzby e-commerce mobile app and authentication API.

## Structure

- `mobile/` — Flutter app (Figma UI + animations)
- `backend/` — Node.js REST API with MySQL

## Prerequisites

- Flutter 3.x
- Node.js 20+
- Docker Desktop (for local MySQL) **or** an existing MySQL 8 instance

## Quick Start

### 1. Start MySQL & Node.js API with Docker

```bash
docker compose up --build -d
```

This starts:
- `grozzby-mysql` on port `3306` (with initialized tables)
- `grozzby-backend` on port `3000` (`http://localhost:3000`)

To view API and database logs:
```bash
docker compose logs -f
```

### 3. Run Flutter app

```bash
cd mobile
flutter pub get
flutter run
```

For Android emulator, the default API URL is `http://10.0.2.2:3000`.

For a physical device, pass your machine IP:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.x.x:3000
```

## Auth Flow

1. Splash animation (~8.3s)
2. Onboarding (3 pages) or Sign In (returning users)
3. Register / Sign In → OTP verification
4. Welcome screen ("Start Shopping" navigation is stubbed)

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/auth/register` | Create account |
| POST | `/api/auth/login` | Sign in |
| POST | `/api/auth/verify-otp` | Verify 6-digit code |
| POST | `/api/auth/resend-otp` | Resend OTP |
| GET | `/api/auth/me` | Current user (JWT) |
