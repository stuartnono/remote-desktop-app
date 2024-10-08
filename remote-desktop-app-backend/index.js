const express = require('express');
const http = require('http');
const socketIO = require('socket.io');
const { exec } = require('child_process');
const robot = require('robotjs');

const app = express();
const server = http.createServer(app);
const io = socketIO(server);

const PORT = 5000;

// Basic route for API
app.get('/', (req, res) => {
    res.send('Remote Desktop Backend is running');
});

// Handle WebSocket connections
io.on('connection', (socket) => {
    console.log('A user connected:', socket.id);

    // Handle mouse movement
    socket.on('mouseMove', (data) => {
        robot.moveMouse(data.x, data.y);
    });

    // Handle mouse click
    socket.on('mouseClick', () => {
        robot.mouseClick();
    });

    // Handle keyboard input
    socket.on('keyPress', (key) => {
        robot.keyTap(key);
    });

    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.id);
    });
});

// API for shutting down the remote machine
app.get('/shutdown', (req, res) => {
    exec('shutdown /s /t 1', (error) => {
        if (error) {
            return res.status(500).send('Error shutting down');
        }
        res.send('Shutting down...');
    });
});

// API for restarting the remote machine
app.get('/restart', (req, res) => {
    exec('shutdown /r /t 1', (error) => {
        if (error) {
            return res.status(500).send('Error restarting');
        }
        res.send('Restarting...');
    });
});

// Start the server
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
