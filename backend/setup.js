import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import authRoutes from './routes/v1/auth.js';
import apiKeyRoutes from './routes/v1/api_keys.js';
import clientRoutes from './routes/v1/clients.js';
import diagnosesRoutes from './routes/v1/diagnoses.js';
import healthProgramRoutes from './routes/v1/health_programs.js';
import { globalErrorHandler } from './middlewares/middlewares.js'


const app = express();
app.use(express.json());
// adds a set of middleware functions that provide security enhancement.
app.use(helmet());
// cors middleware function allows your server to handle requests from different origins (domains).
app.use(cors());
app.use(globalErrorHandler);
app.use(authRoutes);
app.use(apiKeyRoutes);
app.use(clientRoutes);
app.use(diagnosesRoutes);
app.use(healthProgramRoutes);


export default app;