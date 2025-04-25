import express from 'express';
import { authenticateJWT, requireAuth } from '../../middlewares/middlewares.js'
import db from '../../database_connection.js';
const router = express.Router();

// register a new client
router.post('/v1/clients', authenticateJWT, async (req, res, next) => {
    const { first_name, last_name, gender, date_of_birth, contact_info, address, profile_image_path, diagnosis_names } = req.body;
    if (!first_name || !last_name || !gender || !date_of_birth || !contact_info) {
        return res.status(400).json({ error: 'First name, last name, gender, date of birth, and contact info are required' });
    }

    try {
        // get connection to execute transaction
        const connection = await db.getConnection();
        try {
            await connection.beginTransaction();

            // Insert client
            const [result] = await connection.execute(
                'INSERT INTO clients (first_name, last_name, gender, date_of_birth, contact_info, address, user_id, profile_image_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                [first_name, last_name, gender, date_of_birth, contact_info, address, req.user.id, profile_image_path]
            );
            const clientId = result.insertId;

            // Handle diagnoses if provided
            let diagnosisObjects = [];
            if (diagnosis_names && Array.isArray(diagnosis_names) && diagnosis_names.length > 0) {
                const diagnosisIds = [];
                for (const name of diagnosis_names) {
                    if (typeof name !== 'string' || name.trim() === '') {
                        throw new Error('All diagnosis names must be non-empty strings');
                    }
                    const normalizedName = name.trim();
                    const [diagnosisResult] = await connection.execute(
                        'INSERT INTO diagnoses (diagnosis_name) VALUES (?) ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id)',
                        [normalizedName]
                    );
                    diagnosisIds.push(diagnosisResult.insertId);
                }

                const diagnosisEntries = diagnosisIds.map((diagnosisId) => [clientId, diagnosisId]);
                await connection.query('INSERT INTO client_diagnoses (client_id, diagnosis_id) VALUES ?', [diagnosisEntries]);

                // Fetch diagnosis objects for response
                [diagnosisObjects] = await connection.execute(
                    'SELECT id, diagnosis_name FROM diagnoses WHERE id IN (?)',
                    [diagnosisIds]
                );
            }

            await connection.commit();
            res.status(201).json({
                id: clientId,
                first_name,
                last_name,
                gender,
                date_of_birth,
                contact_info,
                address,
                diagnoses: diagnosisObjects
            });
        } catch (error) {
            await connection.rollback();
            throw error;
        } finally {
            connection.release();
        }
    } catch (error) {
        console.error('Client creation error:', error);
        next(error);
    }
});

// enroll a client in one or more health programs
router.post('/v1/clients/:id/enroll', authenticateJWT, async (req, res, next) => {
    const { id } = req.params;
    const { health_program_ids } = req.body;

    if (!Array.isArray(health_program_ids) || health_program_ids.length === 0) {
        return res.status(400).json({ error: 'Health program IDs are required' });
    }

    try {
        const [client] = await db.execute('SELECT * FROM clients WHERE id = ?', [id]);
        if (client.length === 0) return res.status(404).json({ error: 'Client not found' });

        const [programs] = await db.execute('SELECT id FROM health_programs WHERE id IN (?)', [health_program_ids]);
        if (programs.length !== health_program_ids.length) {
            return res.status(400).json({ error: 'One or more health program IDs are invalid' });
        }

        const enrollments = health_program_ids.map((programId) => [id, programId]);
        const connection = await db.getConnection();
        try {
            await connection.beginTransaction();
            await connection.query('INSERT INTO health_program_enrollments (client_id, health_program_id) VALUES ?', [enrollments]);
            await connection.commit();
            res.status(200).json({ message: 'Client enrolled successfully' });
        } catch (error) {
            await connection.rollback();
            throw error;
        } finally {
            connection.release();
        }
    } catch (error) {
        console.error('Enrollment error:', error);
        next(error);
    }
});

// get all clients with pagination support
router.get('/v1/clients', requireAuth, async (req, res, next) => {
    const { page = 1, limit = 10 } = req.query;
    const offset = (page - 1) * limit;

    try {
        const [clients] = await db.execute(
            'SELECT * FROM clients WHERE user_id = ? ORDER BY id LIMIT ? OFFSET ?',
            [req.authType === 'jwt' ? req.user.id : 0, parseInt(limit), parseInt(offset)]
        );

        const clientsWithData = await Promise.all(
            clients.map(async (client) => {
                const [programs] = await db.execute(
                    'SELECT hp.* FROM health_programs hp JOIN health_program_enrollments hpe ON hp.id = hpe.health_program_id WHERE hpe.client_id = ?',
                    [client.id]
                );
                const [diagnoses] = await db.execute(
                    'SELECT d.id, d.diagnosis_name FROM diagnoses d JOIN client_diagnoses cd ON d.id = cd.diagnosis_id WHERE cd.client_id = ?',
                    [client.id]
                );
                const clientData = {
                    id: client.id,
                    first_name: client.first_name,
                    last_name: client.last_name,
                    gender: client.gender,
                    profile_image_path: client.profile_image_path,
                    enrolled_programs: programs,
                    diagnoses,
                };
                if (req.authType === 'jwt') {
                    clientData.date_of_birth = client.date_of_birth;
                    clientData.contact_info = client.contact_info;
                    clientData.address = client.address;
                }
                return clientData;
            })
        );

        res.status(200).json(clientsWithData);
    } catch (error) {
        console.error('Client retrieval error:', error);
        next(error);
    }
});


export default router;