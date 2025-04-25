import 'dotenv/config';
import mysql from 'mysql2/promise';

const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    connectionLimit: 10,
    waitForConnections: true,
    queueLimit: 0,
});

//export a promise_based db connection pool
export default pool;