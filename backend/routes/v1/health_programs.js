import express from 'express';
import { authenticateJWT, requireAuth, validatePagination } from '../../middlewares/middlewares.js'
import db from '../../database_connection.js';
const router = express.Router();

// create a health program
router.post('/v1/health-programs', authenticateJWT, async (req, res, next) => {
    const { name, description, start_date, end_date, image_path, eligibility_criteria } = req.body;


    try {

        // later add a middleware that validates these input, so that the code looks clean
        if (!name || !description || !start_date) {
            throw { statusCode: 400, error: 'Name, description, and start date are required' };
        }

        if (start_date == null) {
            throw { statusCode: 400, error: 'Start date is required.' };
        }

        if ((end_date !== null) && Date(end_date) < Date(start_date)) {
            throw { statusCode: 400, error: 'End date cannot be earlier than the start date.' };

        }

        const connection = await db.getConnection();
        try {
            await connection.beginTransaction();

            let eligibilityCriteriaId = null;
            let eligibilityCriteriaResponse = null;
            if (eligibility_criteria) {
                const { min_age, max_age } = eligibility_criteria;
                if (min_age < 0) {
                    throw { statusCode: 400, error: 'minAge must be a non-negative number' };
                }
                if (max_age < 0) {
                    throw { statusCode: 400, error: 'maxAge must be a non-negative number' };
                }
                if (max_age != null && min_age > max_age) {
                    throw { statusCode: 400, error: 'minAge cannot be greater than maxAge' };
                }
                let diagnosisId = null;
                // run if diagnosis is provided
                if (eligibility_criteria.diagnosis) {
                    let { icd_11_code, diagnosis_name } = eligibility_criteria.diagnosis;
                    const [diagnosisResult] = await connection.execute(
                        'SELECT id FROM diagnoses WHERE icd_11_code = ? AND diagnosis_name = ?',
                        [icd_11_code, diagnosis_name]
                    );

                    diagnosisId = diagnosisResult[0].id;
                }

                const [criteriaResult] = await connection.execute(
                    'INSERT INTO eligibility_criteria (min_age, max_age, diagnosis_id) VALUES (?, ?, ?)',
                    [min_age, max_age, diagnosisId]
                );
                eligibilityCriteriaId = criteriaResult.insertId;
                eligibilityCriteriaResponse = { id: eligibilityCriteriaId, min_age, max_age, diagnosis: eligibility_criteria.diagnosis };
            }

            const [programResult] = await connection.execute(
                'INSERT INTO health_programs (name, description, start_date, end_date, created_by_user_id, image_path, eligibility_criteria_id) VALUES (?, ?, ?, ?, ?, ?, ?)',
                [name, description, start_date, end_date, req.user.id, image_path, eligibilityCriteriaId]
            );

            const [user] = await connection.execute(
                'SELECT id, first_name, last_name, email, phone_number, profile_image_path FROM users WHERE id = ?',
                [req.user.id]
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
                created_by: user[0]
            });
        } catch (error) {
            await connection.rollback();
            console.log(error);
            res.status(error.statusCode).json(error);
        } finally {
            connection.release();
        }
    } catch (error) {
        console.error('Health program creation error:', error);
        res.status(error.statusCode).json(error);
        next(error);
    }
});

// get a specific health program
router.get('/v1/health-programs/:id', requireAuth, async (req, res, next) => {
    const { id } = req.params;

    try {
        const [program] = await db.execute(
            'SELECT hp.*, u.id AS user_id, u.first_name, u.last_name, u.email, u.phone_number, u.profile_image_path ' +
            'FROM health_programs hp JOIN users u ON hp.created_by_user_id = u.id WHERE hp.id = ?',
            [id]
        );
        if (program.length === 0) throw { statusCode: 404, error: 'Health program not found' };

        let eligibilityCriteria = null;
        if (program[0].eligibility_criteria_id) {
            const [criteria] = await db.execute(
                'SELECT ec.id, ec.min_age, ec.max_age, d.id AS diagnosis_id, d.diagnosis_name, d.icd_11_code ' +
                'FROM eligibility_criteria ec LEFT JOIN diagnoses d ON ec.diagnosis_id = d.id WHERE ec.id = ?',
                [program[0].eligibility_criteria_id]
            );

            const { id, min_age, max_age, diagnosis_id, diagnosis_name, icd_11_code } = criteria[0];
            const diagnosis = diagnosis_id ? {
                id: diagnosis_id,
                diagnosis_name: diagnosis_name,
                icd_11_code,
            } : null;

            eligibilityCriteria = {
                id,
                min_age,
                max_age,
                diagnosis
            };

            // eligibilityCriteria = criteria.length > 0 ? criteria[0] : null;
        }

        const programData = {
            id: program[0].id,
            name: program[0].name,
            image_path: program[0].image_path,
            eligibility_criteria: eligibilityCriteria,
            created_by: {
                id: program[0].user_id,
                first_name: program[0].first_name,
                last_name: program[0].last_name,
                email: program[0].email,
                phone_number: program[0].phone_number,
                profile_image_path: program[0].profile_image_path
            }
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
router.get('/v1/health-programs', requireAuth, validatePagination, async (req, res, next) => {
    const { limit, offset } = req.pagination;

    try {
        // sanitize the arguments later
        const [programs] = await db.execute(
            'SELECT hp.*, u.id AS user_id, u.first_name, u.last_name, u.email, u.phone_number, u.profile_image_path ' +
            `FROM health_programs hp JOIN users u ON hp.created_by_user_id = u.id ORDER BY hp.id LIMIT ${limit} OFFSET ${offset}`
        );

        const programsData = await Promise.all(
            programs.map(async (program) => {
                let eligibilityCriteria = null;
                if (program.eligibility_criteria_id) {
                    const [criteria] = await db.execute(
                        'SELECT ec.id, ec.min_age, ec.max_age, d.id AS diagnosis_id, d.diagnosis_name, d.icd_11_code ' +
                        'FROM eligibility_criteria ec LEFT JOIN diagnoses d ON ec.diagnosis_id = d.id WHERE ec.id = ?',
                        [program.eligibility_criteria_id]
                    );

                    const { id, min_age, max_age, diagnosis_id, diagnosis_name, icd_11_code } = criteria[0];
                    const diagnosis = diagnosis_id ? {
                        id: diagnosis_id,
                        diagnosis_name: diagnosis_name,
                        icd_11_code,
                    } : null;

                    eligibilityCriteria = {
                        id,
                        min_age,
                        max_age,
                        diagnosis
                    };

                    // eligibilityCriteria = criteria.length > 0 ? criteria[0] : null;
                }

                const programData = {
                    id: program.id,
                    name: program.name,
                    image_path: program.image_path,
                    eligibility_criteria: eligibilityCriteria,
                    created_by: {
                        id: program.user_id,
                        first_name: program.first_name,
                        last_name: program.last_name,
                        email: program.email,
                        phone_number: program.phone_number,
                        profile_image_path: program.profile_image_path
                    }
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
router.get('/v1/health-programs/search', requireAuth, validatePagination, async (req, res, next) => {
    const { limit, offset } = req.pagination;
    const { q } = req.query;

    try {

        if (!q) throw { statusCode: 400, error: 'Query parameter is required' };

        const [programs] = await db.execute(
            'SELECT hp.*, u.id AS user_id, u.first_name, u.last_name, u.email, u.phone_number, u.profile_image_path ' +
            `FROM health_programs hp JOIN users u ON hp.created_by_user_id = u.id WHERE hp.name LIKE ? ORDER BY hp.id LIMIT ${limit} OFFSET ${offset}`,
            [`%${q}%`]
        );

        const programsData = await Promise.all(
            programs.map(async (program) => {
                let eligibilityCriteria = null;
                if (program.eligibility_criteria_id) {
                    const [criteria] = await db.execute(
                        'SELECT ec.id, ec.min_age, ec.max_age, d.id AS diagnosis_id, d.diagnosis_name, d.icd_11_code ' +
                        'FROM eligibility_criteria ec JOIN diagnoses d ON ec.required_diagnosis_id = d.id WHERE ec.id = ?',
                        [program.eligibility_criteria_id]
                    );
                    const { id, min_age, max_age, diagnosis_id, diagnosis_name, icd_11_code } = criteria[0];
                    const diagnosis = diagnosis_id ? {
                        id: diagnosis_id,
                        diagnosis_name: diagnosis_name,
                        icd_11_code,
                    } : null;

                    eligibilityCriteria = {
                        id,
                        min_age,
                        max_age,
                        diagnosis
                    };

                    // eligibilityCriteria = criteria.length > 0 ? criteria[0] : null;
                }

                const programData = {
                    id: program.id,
                    name: program.name,
                    image_path: program.image_path,
                    eligibility_criteria: eligibilityCriteria,
                    created_by: {
                        id: program.user_id,
                        first_name: program.first_name,
                        last_name: program.last_name,
                        email: program.email,
                        phone_number: program.phone_number,
                        profile_image_path: program.profile_image_path
                    }
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
        res.status(error.statusCode).json(error);
        next(error);
    }
});



// delete a specific health program
router.delete('/v1/health-programs/:id', authenticateJWT, async (req, res, next) => {
    const { id } = req.params;

    try {
        const [program] = await db.execute('SELECT * FROM health_programs WHERE id = ? AND created_by_user_id = ?', [id, req.user.id]);
        if (program.length === 0) {
            throw { statusCode: 404, error: 'Health program not found or action not authorized' };
        }

        await db.execute('DELETE FROM health_programs WHERE id = ?', [id]);
        res.status(200).json({ id: parseInt(id) });
    } catch (error) {
        console.error('Health program deletion error:', error);
        res.status(error.statusCode).json(error);
        next(error);
    }
});

export default router;