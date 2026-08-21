import cors from 'cors';
import express from 'express';
import { env } from './config/env.js';
import authRoutes from './routes/auth.routes.js';
import { errorMiddleware } from './middleware/error.middleware.js';
import { runMigrations } from './db/migrate.js';

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    name: 'Grozzby REST API',
    status: 'online',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      auth: '/api/auth',
    },
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'grozzby-api' });
});

app.use('/api/auth', authRoutes);

app.use(errorMiddleware);

async function startServer() {
  try {
    await runMigrations({ closePool: false });
  } catch (err) {
    console.warn('Startup migration warning (verify DB connection):', err.message);
  }

  app.listen(env.port, '0.0.0.0', () => {
    console.log(`Grozzby API listening on 0.0.0.0:${env.port}`);
  });
}

startServer();
