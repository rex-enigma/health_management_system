import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import db from '../database_connection.js';
dotenv.config();
// key to generate the signature of the jwt token as well as verify the jtw token
export const JWT_SECRET = process.env.JWT_SECRET;

export const authenticateJWT = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ error: 'Invalid or missing token' });
    }

    const token = authHeader.split(' ')[1];
    jwt.verify(token, JWT_SECRET, async (err, user) => {
        if (err) return res.status(403).json({ error: 'Invalid token' });

        // Check if token is revoked. Implement revoked_tokens later
        // const [revoked] = await db.execute('SELECT 1 FROM revoked_tokens WHERE token = ?', [token]);
        // if (revoked.length > 0) return res.status(403).json({ error: 'Token revoked' });

        req.user = user;
        req.authType = 'jwt';
        next();
    });
};

export const validateApiKey = async (req, res, next) => {
    const apiKey = req.headers['x-api-key'];
    if (!apiKey) return res.status(401).json({ error: 'API key is missing' });

    try {
        const [systems] = await db.execute(
            'SELECT * FROM external_systems WHERE status = ?',
            ['active']
        );

        let validSystem = null;
        for (const system of systems) {
            if (await bcrypt.compare(apiKey, system.api_key_hash)) {
                validSystem = system;
                break;
            }
        }

        if (!validSystem) return res.status(403).json({ error: 'Invalid or inactive API key' });

        req.externalSystem = validSystem;
        req.authType = 'apiKey';
        next();
    } catch (error) {
        console.error('API key validation error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const requireAuth = (req, res, next) => {
    const apiKey = req.headers['x-api-key'];
    const authHeader = req.headers['authorization'];

    if (!apiKey && !authHeader) {
        return res.status(401).json({ error: 'Authorization required' });
    }

    if (apiKey) {
        return validateApiKey(req, res, next);
    }

    if (authHeader) {
        return authenticateJWT(req, res, next);
    }
};


export const globalErrorHandler = (err, req, res, next) => {
    console.error('Error:', err.stack);
    res.status(500).json({ error: 'Internal server error' });
};

export const validatePagination = (req, res, next) => {
    const { page = 1, limit = 10 } = req.query;

    // Parse and validate
    const parsedPage = parseInt(page, 10);
    const parsedLimit = parseInt(limit, 10);
    const offset = (parsedPage - 1) * parsedLimit;

    if (isNaN(parsedPage) || parsedPage < 1) {
        return res.status(400).json({ error: 'Invalid page value. Must be a positive integer.' });
    }
    if (isNaN(parsedLimit) || parsedLimit < 1 || parsedLimit > 100) { // Optional: cap max limit
        return res.status(400).json({ error: 'Invalid limit value. Must be between 1 and 100.' });
    }
    if (offset < 0) {
        return res.status(400).json({ error: 'Invalid offset. Check page and limit values.' });
    }

    req.pagination = {
        limit: parsedLimit,
        offset,
        page: parsedPage,
    };

    next();
};