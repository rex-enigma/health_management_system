import app from './setup.js';
import http from 'http';

const PORT = 3000;
const httpServer = http.createServer(app);
httpServer.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
