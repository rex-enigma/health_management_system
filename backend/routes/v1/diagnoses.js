import express from 'express';
import { authenticateJWT, validatePagination } from '../../middlewares/middlewares.js'
import db from '../../database_connection.js';
import axios from 'axios';
import oauth from 'axios-oauth-client';

const router = express.Router();

// get all diagnoses
router.get('/v1/diagnoses', authenticateJWT, validatePagination, async (req, res, next) => {
    const { limit, offset } = req.pagination;

    try {
        // sanitize the arguments later
        const [diagnoses] = await db.execute(
            `SELECT id, diagnosis_name, icd_11_code FROM diagnoses ORDER BY diagnosis_name LIMIT ${limit} OFFSET ${offset}`,
        );
        res.status(200).json({ diagnoses });
    } catch (error) {
        console.error('Diagnosis retrieval error:', error);
        next(error);
    }
});


// Token caching variable
let accessToken = null;
let tokenExpirationTime = null;

// OAuth 2 client for WHO ICD-API
const getClientCredentials = oauth.client(axios.create(), {
    url: 'https://icdaccessmanagement.who.int/connect/token',
    grant_type: 'client_credentials',
    client_id: process.env.WHO_ICD_CLIENT_ID,
    client_secret: process.env.WHO_ICD_CLIENT_SECRET,
    scope: 'icdapi_access'
});

// get or refresh access token
const getAccessToken = async () => {
    const now = Date.now();
    // Check if token exists and is still valid (1 hour = 3600 seconds)
    if (accessToken && tokenExpirationTime && now < tokenExpirationTime) {
        return accessToken;
    }

    try {
        const tokenResponse = await getClientCredentials();
        accessToken = tokenResponse.access_token;
        // Set expiration time (1 hour from now, minus a small buffer of 1 minutes)
        tokenExpirationTime = now + (tokenResponse.expires_in - 60) * 1000;
        return accessToken;
    } catch (error) {
        console.error('Error obtaining access token:', error.message);
        throw new Error('Failed to obtain access token');
    }
};

// Search diagnoses 
router.get('v1/diagnoses/search', authenticateJWT, validatePagination, async (req, res, next) => {
    const { limit, offset } = req.pagination;
    const { q } = req.query;
    if (!q) return res.status(400).json({ status: 'error', error: 'Query parameter is required' });

    let results = [];


    let diagnosesSelectQuery = `SELECT id, diagnosis_name, icd_11_code FROM diagnoses WHERE diagnosis_name LIKE ? ORDER BY diagnosis_name LIMIT ${limit} OFFSET ${offset}`;

    try {

        let connection = await db.getConnection();
        await connection.beginTransaction();

        // Search in local diagnoses table
        // sanitize the arguments later
        const [diagnosesRows] = await connection.execute(diagnosesSelectQuery,
            [`%${q}%`]
        );

        if (diagnosesRows.length > 0) {
            // If matches are found in local table, format and return them
            results = diagnosesRows.map(row => ({
                id: row.id,
                diagnosis_name: row.diagnosis_name,
                icd_11_code: row.icd_11_code
            }));
        } else {
            // Fallback to WHO ICD-API (ICD-11)
            const token = await getAccessToken();

            const icdResponse = await axios.get(`${process.env.WHO_ICD_API_URL}/icd/release/11/2025-01/mms/search`, {
                params: {
                    q: q,
                    highlightingEnabled: 'false', // turn off special tags eg <em></em>
                    flatResults: 'false',
                },
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Accept': 'application/json',
                    'Accept-Language': 'en',
                    'API-Version': 'v2',
                }
            });


            if (!icdResponse.data.destinationEntities || icdResponse.data.destinationEntities.length === 0) {
                console.log(`No matches found in WHO ICD-API for query: ${q}`);
                results = []; // Return empty array if no matches found
            }
            else {
                // Map WHO ICD-API response 
                let diagnosesData = icdResponse.data.destinationEntities.map(item => ([item.title, item.theCode]));
                await connection.query('INSERT INTO diagnoses (diagnosis_name, icd_11_code) VALUES ? ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id)', [diagnosesData]);

                // Search in local diagnoses table
                // sanitize the arguments later
                const [diagnosesRows] = await connection.execute(diagnosesSelectQuery,
                    [`%${q}%`]
                );

                results = diagnosesRows.map(row => ({
                    id: row.id,
                    diagnosis_name: row.diagnosis_name,
                    icd_11_code: row.icd_11_code
                }));
            }

        }

        await connection.commit();

        res.status(200).json(results);

    } catch (error) {
        await connection.rollback();
        console.error('Error searching diagnoses:', error.message);
        next(error);
    }
    finally {
        connection.release();
    };
}
);


export default router;