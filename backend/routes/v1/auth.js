import express from 'express';
import bcrypt from 'bcrypt';
import db from '../../database_connection.js';
const router = express.Router();

router.post('/v1/auth/signup', async (req, res, next) => {
    const { first_name, last_name, email, password, phone_number, profile_image_path } = req.body;
    if (!first_name || !last_name || !email || !password) {
        return res.status(400).json({ error: 'First name, last_name, email, and password are required' });
    }

    try {
        const [existing] = await db.execute('SELECT 1 FROM users WHERE email = ?', [email]);
        if (existing.length > 0) return res.status(409).json({ error: 'Email already exists' });

        const hashedPassword = await bcrypt.hash(password, 10);
        const [result] = await db.execute(
            'INSERT INTO users (first_name, last_name, email, password, phone_number, profile_image_path) VALUES (?, ?, ?, ?, ?, ?)',
            [first_name, last_name, email, hashedPassword, phone_number, profile_image_path]
        );
        res.status(201).json({ id: result.insertId, first_name, last_name, email });
    } catch (error) {
        console.error('Signup error:', error);
        next(error);
    }
});

export default router;