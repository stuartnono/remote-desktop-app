const express = require('express');
const http = require('http');
const socketIO = require('socket.io');
const { exec, spawn } = require('child_process');
const robot = require('robotjs');
const jwt = require('jsonwebtoken');  // For token-based authentication
const rateLimit = require('express-rate-limit');  // For rate limiting
const bodyParser = require('body-parser');

// Initialize Express app and HTTP server
const app = express();
const server = http.createServer(app);
const io = socketIO(server);

// Middleware to parse JSON
app.use(bodyParser.json());

const PORT = 5000;
const secretKey = 'your-secret-key';  // Use a secure key for signing JWTs

// Simple rate limiting for login attempts
const authLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,  // 15 minutes
    max: 100  // Limit each IP to 100 login requests per 15 minutes
});

// Route to serve login requests and generate JWT tokens
app.post('/login', authLimiter, (req, res) => {
    const { username, password } = req.body;

    // Basic username/password check (you can replace this with database validation)
    if (username === 'user' && password === 'pass') {
        // Generate a JWT token
        const token = jwt.sign({ username }, secretKey, { expiresIn: '1h' });  // Expires in 1 hour
        res.json({ token });
    } else {
        res.status(401).json({ message: 'Invalid credentials' });
    }
});

// Middleware to authenticate JWT token for protected routes
function authenticateToken(req, res, next) {
    const token = req.headers['authorization'];  // Get token from 'Authorization' header
    if (!token) return res.status(403).send('Token is required');

    // Verify the token
    jwt.verify(token, secretKey, (err, user) => {
        if (err) return res.status(403).send('Invalid token');
        req.user = user;  // Add the user data to the request object
        next();
    });
}

// Secure WebSocket connection using JWT token
io.use((socket, next) => {
    const token = socket.handshake.query.token;
    if (!token) return next(new Error('Authentication error'));

    // Verify the token
    jwt.verify(token, secretKey, (err, decoded) => {
        if (err) return next(new Error('Authentication error'));
        socket.user = decoded;  // Attach user data to socket
        next();
    });
});

// Basic route for checking if the server is running
app.get('/', (req, res) => {
    res.send('Remote Desktop Backend is running');
});

// Handle WebSocket connections
io.on('connection', (socket) => {
    console.log(`User connected: ${socket.id}`);

    // Start screen capture and stream using FFmpeg
    const ffmpeg = spawn('ffmpeg', [
        '-f', 'gdigrab',  // For capturing desktop on Windows (use x11grab for Linux)
        '-i', 'desktop',  // Capture entire desktop
        '-framerate', '15',  // Adjust frame rate for performance
        '-video_size', '1280x720',  // Adjust resolution as needed
        '-f', 'mpegts', '-',  // Output to stdout
    ]);

    // Send captured screen data to client
    ffmpeg.stdout.on('data', (data) => {
        socket.emit('screenData', data);
    });

    ffmpeg.stderr.on('data', (data) => {
        console.error(`FFmpeg error: ${data}`);
    });

    ffmpeg.on('close', (code) => {
        console.log(`FFmpeg process closed with code ${code}`);
    });

    // Handle mouse movement
    socket.on('mouseMove', (data) => {
        robot.moveMouse(data.x, data.y);
    });

    // Handle mouse click
    socket.on('mouseClick', () => {
        robot.mouseClick();
    });

    // Handle mouse drag
    socket.on('mouseDrag', (data) => {
        robot.mouseToggle('down');
        robot.moveMouse(data.x, data.y);
    });

    socket.on('mouseUp', () => {
        robot.mouseToggle('up');
    });

    // Handle keyboard input
    socket.on('keyPress', (keys) => {
        keys.forEach((key) => {
            robot.keyTap(key);
        });
    });

    // Handle client disconnect
    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.id);
        ffmpeg.kill('SIGINT');  // Stop FFmpeg process
    });
});

// API endpoint to shut down the remote machine
app.get('/shutdown', authenticateToken, (req, res) => {
    exec('shutdown /s /t 1', (error, stdout, stderr) => {
        if (error) {
            console.error(`Shutdown error: ${error.message}`);
            return res.status(500).send('Error executing shutdown');
        }
        res.send('Shutting down...');
    });
});

// API endpoint to restart the remote machine
app.get('/restart', authenticateToken, (req, res) => {
    exec('shutdown /r /t 1', (error, stdout, stderr) => {
        if (error) {
            console.error(`Restart error: ${error.message}`);
            return res.status(500).send('Error executing restart');
        }
        res.send('Restarting...');
    });
});

// Start the server
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
