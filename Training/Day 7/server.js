import express from 'express';
import portsRouter from './routes/ports.routes.js'

const app = express();
const PORT = 3000;

app.use(express.json());

app.use((req, _res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

app.use('/ports', portsRouter);

app.get('/', (_req, res) => {
  res.json({ message: 'Ports API running' });
});

app.use((_req, res) => {
  res.status(404).json({ success: false, error: 'Route not found' });
});

app.listen(PORT, () => {
  console.log(`Ports API running on http://localhost:${PORT}`);
});
