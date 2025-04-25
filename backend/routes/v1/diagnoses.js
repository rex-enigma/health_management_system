import express from 'express';
import { authenticateJWT } from '../../middlewares/middlewares.js'
import db from '../../database_connection.js';

const router = express.Router();

// get all diagnoses
router.get('/v1/diagnoses', authenticateJWT, async (req, res, next) => {
    const { page = 1, limit = 10 } = req.query;
    const offset = (page - 1) * limit;

    try {
        const [diagnoses] = await db.execute(
            'SELECT id, diagnosis_name FROM diagnoses ORDER BY diagnosis_name LIMIT ? OFFSET ?',
            [parseInt(limit), parseInt(offset)]
        );
        res.status(200).json({ diagnoses });
    } catch (error) {
        console.error('Diagnosis retrieval error:', error);
        next(error);
    }
});


export default router;