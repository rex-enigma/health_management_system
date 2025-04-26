import express from 'express';
import { authenticateJWT, requireAuth, validatePagination } from '../../middlewares/middlewares.js'
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

            const [user] = await connection.execute(
                'SELECT id, first_name, last_name, email, phone_number, profile_image_path FROM users WHERE id = ?',
                [req.user.id]
            );

            await connection.commit();
            res.status(201).json({
                id: clientId,
                first_name,
                last_name,
                gender,
                date_of_birth,
                contact_info,
                address,
                diagnoses: diagnosisObjects,
                registered_by: user[0]
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

// get all clients with pagination support. External systems with api keys can use this endpoint
router.get('/v1/clients', requireAuth, validatePagination, async (req, res, next) => {
    const { limit, offset } = req.pagination;

    try {
        // sanitize the arguments later
        const [clients] = await db.execute(
            'SELECT c.*, u.id AS user_id, u.first_name, u.last_name, u.email, u.phone_number, u.profile_image_path ' +
            `FROM clients c JOIN users u ON c.user_id = u.id WHERE c.user_id = ? ORDER BY c.id LIMIT ${limit} OFFSET ${offset}`
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
                    registered_by: {
                        id: client.user_id,
                        first_name: client.first_name,
                        last_name: client.last_name,
                        email: client.email,
                        phone_number: client.phone_number,
                        profile_image_path: client.profile_image_path
                    }
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

// search for clients (with pagination support). External systems with api keys can use this endpoint
router.get('/v1/clients/search', requireAuth, validatePagination, async (req, res, next) => {
    const { limit, offset } = req.pagination;
    const { query } = req.query;
    if (!query) return res.status(400).json({ error: 'Query parameter is required' });

    try {
        // sanitize the arguments later
        const [clients] = await db.execute(
            'SELECT c.*, u.id AS user_id, u.first_name, u.last_name, u.email, u.phone_number, u.profile_image_path ' +
            `FROM clients c JOIN users u ON c.user_id = u.id WHERE (c.first_name LIKE ? OR c.last_name LIKE ?) AND c.user_id = ? ORDER BY c.id LIMIT ${limit} OFFSET ${offset}`,
            [`%${query}%`, `%${query}%`]
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
                    registered_by: {
                        id: client.user_id,
                        first_name: client.first_name,
                        last_name: client.last_name,
                        email: client.email,
                        phone_number: client.phone_number,
                        profile_image_path: client.profile_image_path
                    }
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
        console.error('Client search error:', error);
        next(error);
    }
});

// get a specific client. External systems with api keys can use this endpoint
router.get('/v1/clients/:id', requireAuth, async (req, res, next) => {
    const { id } = req.params;

    try {
        const [client] = await db.execute('SELECT c.*, u.id AS user_id, u.first_name, u.last_name, u.email, u.phone_number, u.profile_image_path ' +
            'FROM clients c JOIN users u ON c.user_id = u.id WHERE c.id = ?', [id]);
        if (client.length === 0) return res.status(404).json({ error: 'Client not found or not authorized' });

        const [programs] = await db.execute(
            'SELECT hp.* FROM health_programs hp JOIN health_program_enrollments hpe ON hp.id = hpe.health_program_id WHERE hpe.client_id = ?',
            [id]
        );
        const [diagnoses] = await db.execute(
            'SELECT d.id, d.diagnosis_name FROM diagnoses d JOIN client_diagnoses cd ON d.id = cd.diagnosis_id WHERE cd.client_id = ?',
            [id]
        );

        const profile = {
            id: client[0].id,
            first_name: client[0].first_name,
            last_name: client[0].last_name,
            gender: client[0].gender,
            profile_image_path: client[0].profile_image_path,
            enrolled_programs: programs,
            diagnoses,
            registered_by: {
                id: client[0].user_id,
                first_name: client[0].first_name,
                last_name: client[0].last_name,
                email: client[0].email,
                phone_number: client[0].phone_number,
                profile_image_path: client[0].profile_image_path
            }
        };

        if (req.authType === 'jwt') {
            profile.date_of_birth = client[0].date_of_birth;
            profile.contact_info = client[0].contact_info;
            profile.address = client[0].address;
        }

        res.status(200).json(profile);
    } catch (error) {
        console.error('Client profile error:', error);
        next(error);
    }
});

// delete a specific client
router.delete('/v1/clients/:id', authenticateJWT, async (req, res, next) => {
    const { id } = req.params;

    try {
        const [client] = await db.execute('SELECT * FROM clients WHERE id = ? AND user_id = ?', [id, req.user.id]);
        if (client.length === 0) {
            return res.status(404).json({ error: 'Client not found or not authorized' });
        }

        await db.execute('DELETE FROM clients WHERE id = ?', [id]);
        res.status(200).json({ id: parseInt(id) });
    } catch (error) {
        console.error('Client deletion error:', error);
        next(error);
    }
});

export default router;