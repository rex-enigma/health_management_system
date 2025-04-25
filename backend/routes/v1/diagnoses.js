import express from 'express';
import { authenticateJWT, validatePagination } from '../../middlewares/middlewares.js'
import db from '../../database_connection.js';

const router = express.Router();

// get all diagnoses
router.get('/v1/diagnoses', validatePagination, async (req, res, next) => {
    const { limit, offset } = req.pagination;

    try {
        const [diagnoses] = await db.execute(
            `SELECT id, diagnosis_name FROM diagnoses ORDER BY diagnosis_name LIMIT ${limit} OFFSET ${offset}`,
        );
        res.status(200).json({ diagnoses });
    } catch (error) {
        console.error('Diagnosis retrieval error:', error);
        next(error);
    }
});


export default router;