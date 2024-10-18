const { exec } = require('child_process');
const { authenticateToken } = require('./auth');

module.exports = (app) => {
    // Shutdown API
    app.get('/shutdown', authenticateToken, (req, res) => {
        exec('shutdown /s /t 1', (error, stdout, stderr) => {
            if (error) {
                console.error(`Shutdown error: ${error.message}`);
                return res.status(500).send('Error executing shutdown');
            }
            res.send('Shutting down...');
        });
    });

    // Restart API
    app.get('/restart', authenticateToken, (req, res) => {
        exec('shutdown /r /t 1', (error, stdout, stderr) => {
            if (error) {
                console.error(`Restart error: ${error.message}`);
                return res.status(500).send('Error executing restart');
            }
            res.send('Restarting...');
        });
    });
};
