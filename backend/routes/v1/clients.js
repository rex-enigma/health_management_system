import express from 'express';
import { authenticateJWT, requireAuth, validatePagination } from '../../middlewares/middlewares.js'
import db from '../../database_connection.js';
const router = express.Router();

// register a new client
router.post('/v1/clients', authenticateJWT, async (req, res, next) => {
    const { first_name, last_name, gender, date_of_birth, contact_info, address, profile_image_path, diagnosis_ids } = req.body;
    if (!first_name || !last_name || !gender || !date_of_birth || !contact_info) {
        return res.status(400).json({ error: 'First name, last name, gender, date of birth, and contact info are required' });
    }

    try {
        // get connection to execute transaction
        const connection = await db.getConnection();
        try {
            await connection.beginTransaction();

            // check for existing client
            const [existingClient] = await connection.execute(
                'SELECT id FROM clients WHERE first_name = ? AND last_name = ? AND date_of_birth = ? AND contact_info = ?',
                [first_name, last_name, date_of_birth, contact_info]
            );

            if (existingClient.length > 0) throw { statusCode: 409, error: 'Client already exists' };


            // Insert client
            const [result] = await connection.execute(
                'INSERT INTO clients (first_name, last_name, gender, date_of_birth, contact_info, address, user_id, profile_image_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                [first_name, last_name, gender, date_of_birth, contact_info, address, req.user.id, profile_image_path]
            );
            const clientId = result.insertId;

            // Handle diagnoses if provided
            let diagnosisObjects = [];
            if (diagnosis_ids && Array.isArray(diagnosis_ids) && diagnosis_ids.length > 0) {
                let diagnosisIds = [];

                const sanitizedDiagnosisIds = diagnosis_ids.map((diagnosisId) => connection.escape(diagnosisId)).join(', ');
                const [diagnosisResults] = await connection.execute(`SELECT id FROM diagnoses WHERE id IN (${sanitizedDiagnosisIds})`);
                if (diagnosisResults.length !== diagnosis_ids.length) throw { statusCode: 400, error: 'One or more Diagnosis IDs are invalid' };


                diagnosisIds = diagnosisResults.map((diagnosisRow) => diagnosisRow.id);

                const diagnosisEntries = diagnosisIds.map((diagnosisId) => [clientId, diagnosisId]);
                const sanitizedDiagnosisEntries = diagnosisEntries
                    .map(([clientId, diagnosisId]) => `(${connection.escape(clientId)}, ${connection.escape(diagnosisId)})`)
                    .join(', ');
                await connection.query(`INSERT INTO client_diagnoses (client_id, diagnosis_id) VALUES ${sanitizedDiagnosisEntries}`);

                // Fetch diagnosis objects for response
                [diagnosisObjects] = await connection.execute(
                    `SELECT id, diagnosis_name, icd_11_code FROM diagnoses WHERE id IN (${sanitizedDiagnosisIds})`);
            }

            const [user] = await connection.execute(
                'SELECT id, first_name, last_name, email, phone_number, profile_image_path FROM users WHERE id = ?',
                [req.user.id]
            );

            await connection.commit();
            res.status(201).json({
                id: clientId,
                profile_image_path,
                first_name,
                last_name,
                gender,
                date_of_birth,
                contact_info,
                address,
                enrolled_programs: [],
                diagnoses: diagnosisObjects,
                registered_by: user[0]
            });
        } catch (error) {
            await connection.rollback();
            res.status(error.statusCode).json(error);
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
        throw { statusCode: 400, error: 'Health program IDs are required' }
    }

    try {
        const [client] = await db.execute('SELECT * FROM clients WHERE id = ?', [id]);
        if (client.length === 0) return res.status(404).json({ error: 'Client not found' });

        const sanitizedHealthProgramIds = health_program_ids.map((healthProgramId) => db.escape(healthProgramId)).join(', ');
        const [programResults] = await db.execute(`SELECT id FROM health_programs WHERE id IN (${sanitizedHealthProgramIds})`);
        if (programResults.length !== health_program_ids.length) {
            throw { statusCode: 400, error: 'One or more health program IDs are invalid' }
        }



        const connection = await db.getConnection();
        try {
            await connection.beginTransaction();

            const enrollments = health_program_ids.map((programId) => [id, programId]);
            const sanitizedEnrollments = enrollments
                .map(([clientId, healthProgramId]) => `(${connection.escape(clientId)}, ${connection.escape(healthProgramId)})`)
                .join(', ');
            await connection.execute(`INSERT INTO health_program_enrollments (client_id, health_program_id) VALUES ${sanitizedEnrollments}`);

            await connection.commit();

            res.status(200).json({ message: 'Client enrolled successfully' });
        } catch (error) {
            await connection.rollback();
            res.status(error.statusCode).json(error);
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

        const [clients] = await db.execute(
            'SELECT c.*, u.id AS user_id, u.first_name AS user_first_name, u.last_name AS user_last_name, u.email, u.phone_number, u.profile_image_path ' +
            `FROM clients c JOIN users u ON c.user_id = u.id ORDER BY c.id LIMIT ${limit} OFFSET ${offset}`
        );

        const clientsWithData = await Promise.all(
            clients.map(async (client) => {
                // fetch all health programs the client is enrolled in. Empty list is returned if the client isn't enrolled in any health program
                let cleanedHealthPrograms = await getHealthPrograms(client.id);
                console.log(cleanedHealthPrograms);
                // fetch diagnosis for the client. diagnoses is an empty list if the client doesn't have any condition he has been diagnosed with
                const [diagnoses] = await db.execute(
                    'SELECT d.id, d.diagnosis_name, d.icd_11_code FROM diagnoses d JOIN client_diagnoses cd ON d.id = cd.diagnosis_id WHERE cd.client_id = ?',
                    [client.id]
                );

                const clientData = {
                    id: client.id,
                    first_name: client.first_name,
                    last_name: client.last_name,
                    gender: client.gender,
                    profile_image_path: client.profile_image_path,
                    enrolled_programs: cleanedHealthPrograms,
                    diagnoses: diagnoses.map((diagnosis) => ({
                        id: diagnosis.id,
                        diagnosis_name: diagnosis.diagnosis_name,
                        icd_11_code: diagnosis.icd_11_code
                    })),
                    registered_by: {
                        id: client.user_id,
                        first_name: client.user_first_name,
                        last_name: client.user_last_name,
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
    const { q } = req.query;

    try {
        if (!q) throw { status: 400, message: 'Query parameter is required', };

        const [clients] = await db.execute(
            'SELECT c.*, u.id AS user_id, u.first_name, u.last_name, u.email, u.phone_number, u.profile_image_path ' +
            `FROM clients c JOIN users u ON c.user_id = u.id WHERE(c.first_name LIKE ? OR c.last_name LIKE ?) ORDER BY c.id LIMIT ${limit} OFFSET ${offset}`,
            [`% ${q} % `, ` % ${q} % `]
        );

        const clientsWithData = await Promise.all(
            clients.map(async (client) => {
                // fetch all health programs the client is enrolled in. Empty list is returned if the client isn't enrolled in any health program
                let cleanedHealthPrograms = await getHealthPrograms(client.id);

                // fetch diagnosis for the client. diagnoses is an empty list if the client doesn't have any condition he has been diagnosed with
                const [diagnoses] = await db.execute(
                    'SELECT d.id, d.diagnosis_name, d.icd_11_code FROM diagnoses d JOIN client_diagnoses cd ON d.id = cd.diagnosis_id WHERE cd.client_id = ?',
                    [client.id]
                );

                const clientData = {
                    id: client.id,
                    first_name: client.first_name,
                    last_name: client.last_name,
                    gender: client.gender,
                    profile_image_path: client.profile_image_path,
                    enrolled_programs: cleanedHealthPrograms,
                    diagnoses: diagnoses.map((diagnosis) => ({
                        id: diagnosis.id,
                        diagnosis_name: diagnosis.diagnosis_name,
                        icd_11_code: diagnosis.icd_11_code
                    })),
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
        res.status(error.statusCode).json(error);
        next(error);
    }
});

// get a specific client of the given id. External systems with api keys can use this endpoint
router.get('/v1/clients/:id', requireAuth, async (req, res, next) => {
    const { id } = req.params;

    try {
        // fetch the client and its associated user details
        const [client] = await db.execute(
            `SELECT c.*, u.id AS user_id, u.first_name AS user_first_name, u.last_name AS user_last_name, u.email, u.phone_number, u.profile_image_path 
             FROM clients c JOIN users u ON c.user_id = u.id WHERE c.id = ?`, [id]);
        if (client.length === 0) throw { statusCode: 404, error: 'Client not found' };

        // fetch all health programs the client is enrolled in. empty list is returned if the client isn't enrolled in any health program
        let cleanedHealthPrograms = await getHealthPrograms(id);

        // fetch diagnosis for the client. diagnoses is an empty list if the client doesn't have any condition he has been diagnosed with
        const [diagnoses] = await db.execute(
            `SELECT d.id, d.diagnosis_name, d.icd_11_code 
            FROM diagnoses d JOIN client_diagnoses cd ON d.id = cd.diagnosis_id WHERE cd.client_id = ?`,
            [id]
        );

        const clientData = {
            id: client[0].id,
            first_name: client[0].first_name,
            last_name: client[0].last_name,
            gender: client[0].gender,
            profile_image_path: client[0].profile_image_path,
            enrolled_programs: cleanedHealthPrograms,
            diagnoses: diagnoses.map((diagnosis) => ({
                id: diagnosis.id,
                diagnosis_name: diagnosis.diagnosis_name,
                icd_11_code: diagnosis.icd_11_code
            })),
            registered_by: {
                id: client[0].user_id,
                first_name: client[0].user_first_name,
                last_name: client[0].user_last_name,
                email: client[0].email,
                phone_number: client[0].phone_number,
                profile_image_path: client[0].profile_image_path
            }
        };

        if (req.authType === 'jwt') {
            clientData.date_of_birth = client[0].date_of_birth;
            clientData.contact_info = client[0].contact_info;
            clientData.address = client[0].address;
        }

        res.status(200).json(clientData);
    } catch (error) {
        console.error('Client profile error:', error);
        res.status(error.statusCode).json(error);
        next(error);
    }
});

// fetch health programs the client [clientId] is enrolled in
async function getHealthPrograms(clientId) {

    const [programs] = await db.execute(
        `SELECT id, image_path, name, description, start_date, end_date, created_at, created_by_user_id, eligibility_criteria_id
         FROM health_programs hp 
         JOIN health_program_enrollments hpe ON hp.id = hpe.health_program_id 
         WHERE hpe.client_id = ?`,
        [clientId]
    );

    if (programs.length === 0) return [];

    // fetch user details for each program
    const programsWithUsers = await Promise.all(
        programs.map(async (program) => {
            const [user] = await db.execute(
                `SELECT id, first_name, last_name, email, phone_number, profile_image_path 
                 FROM users WHERE id = ?`,
                [program.created_by_user_id]
            );

            return {
                ...program,
                created_by: user[0]
            };
        })
    );

    // fetch eligibility criteria for each program
    const programsWithEligibility = await Promise.all(
        programsWithUsers.map(async (program) => {
            // handled eligibility if not provided for the given program 
            if (!program.eligibility_criteria_id) {
                return {
                    ...program,
                    eligibility_criteria: null,
                };
            }

            const [eligibility] = await db.execute(
                `SELECT ec.id, ec.min_age, ec.max_age, d.id AS diagnosis_id, d.diagnosis_name, d.icd_11_code 
                         FROM eligibility_criteria ec 
                         LEFT JOIN diagnoses d ON ec.diagnosis_id = d.id 
                         WHERE ec.id = ?`,
                [program.eligibility_criteria_id]
            );

            return {
                ...program,
                eligibility_criteria: {
                    id: eligibility[0].id,
                    min_age: eligibility[0].min_age,
                    max_age: eligibility[0].max_age,
                    diagnosis: eligibility[0].diagnosis_id
                        ? {
                            id: eligibility[0].diagnosis_id,
                            diagnosis_name: eligibility[0].diagnosis_name,
                            icd_11_code: eligibility[0].icd_11_code,
                        }
                        : null,
                }
                ,
            };
        })
    );

    // return health programs the client is enrolled in without their foreign keys
    return programsWithEligibility.map(({ eligibility_criteria_id, created_by_user_id, ...rest }) => rest);
}

// delete a specific client
router.delete('/v1/clients/:id', authenticateJWT, async (req, res, next) => {
    const { id } = req.params;

    try {
        const [client] = await db.execute('SELECT * FROM clients WHERE id = ? AND user_id = ?', [id, req.user.id]);
        if (client.length === 0) throw { statusCode: 404, error: 'Client not found' };

        await db.execute('DELETE FROM clients WHERE id = ?', [id]);
        res.status(200).json({ id: parseInt(id) });
    } catch (error) {
        console.error('Client deletion error:', error);
        res.status(error.statusCode).json(error);
        next(error);
    }
});

export default router;