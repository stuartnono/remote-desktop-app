const crypto = require('crypto');
const robot = require('robotjs');

const activeSessions = {};  // Store active sessions

// Function to generate a unique session code
function generateSessionCode() {
    return crypto.randomBytes(3).toString('hex');  // 6-character session code
}

module.exports = (io) => {
    io.on('connection', (socket) => {
        console.log(`New connection: ${socket.id}`);
        
        // When the host starts the session
        socket.on('startHostSession', () => {
            const sessionCode = generateSessionCode();
            activeSessions[sessionCode] = { hostSocket: socket };
            socket.emit('sessionCode', sessionCode);  // Send session code to the host
            console.log(`Host started session: ${sessionCode}`);
        });
   
        // When a controller joins using a session code
        socket.on('joinSession', (sessionCode) => {
            const session = activeSessions[sessionCode];
            if (session && session.hostSocket) {
                session.controllerSocket = socket;
                socket.emit('sessionJoined', true);  // Notify controller of successful connection
                session.hostSocket.emit('controllerConnected', true);  // Notify host of controller connection
                console.log(`Controller joined session: ${sessionCode}`);
            } else {
                socket.emit('sessionError', 'Invalid session code');
            }
        });

        // Mouse movement relay from controller to host
        socket.on('mouseMove', (sessionCode, data) => {
            const session = activeSessions[sessionCode];
            if (session && session.hostSocket) {
                session.hostSocket.emit('mouseMove', data);  // Forward mouse move to host
            }
        });

        // Key press relay from controller to host
        socket.on('keyPress', (sessionCode, keys) => {
            const session = activeSessions[sessionCode];
            if (session && session.hostSocket) {
                session.hostSocket.emit('keyPress', keys);  // Forward key press to host
            }
        });

        // Handle disconnection of host or controller
        socket.on('disconnect', () => {
            Object.keys(activeSessions).forEach(sessionCode => {
                const session = activeSessions[sessionCode];
                if (session.hostSocket === socket || session.controllerSocket === socket) {
                    delete activeSessions[sessionCode];  // Remove session on disconnect
                    console.log(`Session ended: ${sessionCode}`);
                }
            });
        });
    });
};
