import express from 'express';
import bcrypt from 'bcrypt';
import db from '../../database_connection.js';
const router = express.Router();

router.post('/v1/generate-api-key', async (req, res, next) => {
    const { system_name, contact_email } = req.body;
    if (!system_name || !contact_email) {
        return res.status(400).json({ error: 'System name and contact email are required' });
    }

    const apiKey = crypto.randomBytes(32).toString('hex');
    const hashedApiKey = await bcrypt.hash(apiKey, 10);

    try {
        const [result] = await db.execute(
            'INSERT INTO external_systems (system_name, contact_email, api_key_hash, status) VALUES (?, ?, ?, ?)',
            [system_name, contact_email, hashedApiKey, 'active']
        );
        res.status(201).json({ id: result.insertId, system_name, contact_email, api_key: apiKey });
    } catch (error) {
        console.error('API key generation error:', error);
        next(error);
    }
});

export default router;