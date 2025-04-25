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

// 
router.post('/v1/auth/login', async (req, res, next) => {
    const { email, password } = req.body;

    try {
        const [user] = await db.execute('SELECT * FROM users WHERE email = ?', [email]);
        if (user.length === 0 || !(await bcrypt.compare(password, user[0].password))) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const token = jwt.sign(
            { id: user[0].id, email: user[0].email },
            JWT_SECRET,
            { expiresIn: '1h' }
        );
        res.status(200).json({
            token,
            user: {
                id: user.id,
                first_name: user.first_name,
                last_name: user.last_name,
                email: user.email,
                phone_number: user.phone_number,
                profile_image_path: user.profile_image_path
            }
        });
    } catch (error) {
        console.error('Login error:', error);
        next(error);
    }
});

export default router;