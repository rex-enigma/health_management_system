import express from 'express';
import mysql from 'mysql2/promise';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import crypto from 'crypto';
import helmet from 'helmet';
import cors from 'cors';
import dotenv from 'dotenv';
import { authenticateJWT } from '../../middlewares/middlewares.js'
import db from '../../database_connection.js';
const router = express.Router();

// create a health program
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

// get a specific health program
router.get('/v1/health-programs/:id', requireAuth, async (req, res, next) => {
    const { id } = req.params;

    try {
        const [program] = await db.execute('SELECT * FROM health_programs WHERE id = ?', [id]);
        if (program.length === 0) return res.status(404).json({ error: 'Health program not found' });

        let eligibilityCriteria = null;
        if (program[0].eligibility_criteria_id) {
            const [criteria] = await db.execute(
                'SELECT ec.id, ec.min_age AS minAge, ec.max_age AS maxAge, d.diagnosis_name AS diagnosis_name ' +
                'FROM eligibility_criteria ec JOIN diagnoses d ON ec.required_diagnosis_id = d.id WHERE ec.id = ?',
                [program[0].eligibility_criteria_id]
            );
            eligibilityCriteria = criteria.length > 0 ? criteria[0] : null;
        }

        const programData = {
            id: program[0].id,
            name: program[0].name,
            image_path: program[0].image_path,
            eligibility_criteria: eligibilityCriteria,
        };

        if (req.authType === 'jwt') {
            programData.description = program[0].description;
            programData.start_date = program[0].start_date;
            programData.end_date = program[0].end_date;
        }

        res.status(200).json(programData);
    } catch (error) {
        console.error('Health program retrieval error:', error);
        next(error);
    }
});

// get all health programs with pagination
router.get('/v1/health-programs', requireAuth, async (req, res, next) => {
    const { page = 1, limit = 10 } = req.query;
    const offset = (page - 1) * limit;

    try {
        const [programs] = await db.execute(
            'SELECT * FROM health_programs ORDER BY id LIMIT ? OFFSET ?',
            [parseInt(limit), parseInt(offset)]
        );

        const programsData = await Promise.all(
            programs.map(async (program) => {
                let eligibilityCriteria = null;
                if (program.eligibility_criteria_id) {
                    const [criteria] = await db.execute(
                        'SELECT ec.id, ec.min_age AS minAge, ec.max_age AS maxAge, d.diagnosis_name AS diagnosis_name ' +
                        'FROM eligibility_criteria ec JOIN diagnoses d ON ec.required_diagnosis_id = d.id WHERE ec.id = ?',
                        [program[0].eligibility_criteria_id]
                    );
                    eligibilityCriteria = criteria.length > 0 ? criteria[0] : null;
                }

                const programData = {
                    id: program.id,
                    name: program.name,
                    image_path: program.image_path,
                    eligibility_criteria: eligibilityCriteria,
                };
                if (req.authType === 'jwt') {
                    programData.description = program.description;
                    programData.start_date = program.start_date;
                    programData.end_date = program.end_date;
                }
                return programData;
            })
        );

        res.status(200).json(programsData);
    } catch (error) {
        console.error('Health program retrieval error:', error);
        next(error);
    }
});

// search for health programs with pagination
router.get('/v1/health-programs/search', requireAuth, async (req, res, next) => {
    const { query, page = 1, limit = 10 } = req.query;
    if (!query) return res.status(400).json({ error: 'Query parameter is required' });

    const offset = (page - 1) * limit;

    try {
        const [programs] = await db.execute(
            'SELECT * FROM health_programs WHERE name LIKE ? ORDER BY id LIMIT ? OFFSET ?',
            [`%${query}%`, parseInt(limit), parseInt(offset)]
        );

        const programsData = await Promise.all(
            programs.map(async (program) => {
                let eligibilityCriteria = null;
                if (program.eligibility_criteria_id) {
                    const [criteria] = await db.execute(
                        'SELECT ec.id, ec.min_age AS minAge, ec.max_age AS maxAge, d.diagnosis_name AS diagnosis_name ' +
                        'FROM eligibility_criteria ec JOIN diagnoses d ON ec.required_diagnosis_id = d.id WHERE ec.id = ?',
                        [program.eligibility_criteria_id]
                    );
                    eligibilityCriteria = criteria.length > 0 ? criteria[0] : null;
                }

                const programData = {
                    id: program.id,
                    name: program.name,
                    image_path: program.image_path,
                    eligibility_criteria: eligibilityCriteria,
                };
                if (req.authType === 'jwt') {
                    programData.description = program.description;
                    programData.start_date = program.start_date;
                    programData.end_date = program.end_date;
                }
                return programData;
            })
        );

        res.status(200).json(programsData);
    } catch (error) {
        console.error('Health program search error:', error);
        next(error);
    }
});

router.delete('/v1/health-programs/:id', authenticateJWT, async (req, res, next) => {
    const { id } = req.params;

    try {
        const [program] = await db.execute('SELECT * FROM health_programs WHERE id = ? AND created_by_user_id = ?', [id, req.user.id]);
        if (program.length === 0) {
            return res.status(404).json({ error: 'Health program not found or not authorized' });
        }

        await db.execute('DELETE FROM health_programs WHERE id = ?', [id]);
        res.status(200).json({ id: parseInt(id) });
    } catch (error) {
        console.error('Health program deletion error:', error);
        next(error);
    }
});

// delete a specific health program
router.delete('/v1/health-programs/:id', authenticateJWT, async (req, res, next) => {
    const { id } = req.params;

    try {
        const [program] = await db.execute('SELECT * FROM health_programs WHERE id = ? AND created_by_user_id = ?', [id, req.user.id]);
        if (program.length === 0) {
            return res.status(404).json({ error: 'Health program not found or not authorized' });
        }

        await db.execute('DELETE FROM health_programs WHERE id = ?', [id]);
        res.status(200).json({ id: parseInt(id) });
    } catch (error) {
        console.error('Health program deletion error:', error);
        next(error);
    }
});

export default router;