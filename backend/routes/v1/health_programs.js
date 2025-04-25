import express from 'express';
import db from '../../database_connection.js';
const router = express.Router();

router.post('/v1/health-programs', authenticateJWT, async (req, res, next) => {
    const { name, description, start_date, end_date, image_path, eligibility_criteria } = req.body;
    if (!name || !description || !start_date) {
        return res.status(400).json({ error: 'Name, description, and start date are required' });
    }

    try {
        const connection = await db.getConnection();
        try {
            await connection.beginTransaction();

            let eligibilityCriteriaId = null;
            let eligibilityCriteriaResponse = null;
            if (eligibility_criteria) {
                const { minAge, maxAge, diagnosis_name } = eligibility_criteria;
                if (!diagnosis_name) {
                    throw new Error('Eligibility criteria diagnosis_name is required');
                }
                if (minAge !== undefined && (typeof minAge !== 'number' || minAge < 0)) {
                    throw new Error('minAge must be a non-negative number');
                }
                if (maxAge !== undefined && (typeof maxAge !== 'number' || maxAge < 0)) {
                    throw new Error('maxAge must be a non-negative number');
                }
                if (minAge !== undefined && maxAge !== undefined && minAge > maxAge) {
                    throw new Error('minAge cannot be greater than maxAge');
                }

                // Look up or create diagnosis
                const [diagnosisResult] = await connection.execute(
                    'INSERT INTO diagnoses (diagnosis_name) VALUES (?) ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id)',
                    [diagnosis_name]
                );
                const diagnosisId = diagnosisResult.insertId;

                const [criteriaResult] = await connection.execute(
                    'INSERT INTO eligibility_criteria (min_age, max_age, required_diagnosis_id) VALUES (?, ?, ?)',
                    [minAge || null, maxAge || null, diagnosisId]
                );
                eligibilityCriteriaId = criteriaResult.insertId;
                eligibilityCriteriaResponse = { minAge, maxAge, diagnosis_name };
            }

            const [programResult] = await connection.execute(
                'INSERT INTO health_programs (name, description, start_date, end_date, created_by_user_id, image_path, eligibility_criteria_id) VALUES (?, ?, ?, ?, ?, ?, ?)',
                [name, description, start_date, end_date, req.user.id, image_path, eligibilityCriteriaId]
            );

            await connection.commit();

            res.status(201).json({
                id: programResult.insertId,
                name,
                description,
                start_date,
                end_date,
                image_path,
                eligibility_criteria: eligibilityCriteriaResponse,
            });
        } catch (error) {
            await connection.rollback();
            throw error;
        } finally {
            connection.release();
        }
    } catch (error) {
        console.error('Health program creation error:', error);
        next(error);
    }
});