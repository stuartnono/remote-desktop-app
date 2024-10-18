const { spawn } = require('child_process');
const robot = require('robotjs');

module.exports = (io) => {
    io.on('connection', (socket) => {
        console.log(`User connected: ${socket.id}`);

        // Start FFmpeg process for screen capture
        const ffmpeg = spawn('ffmpeg', [
            '-f', 'gdigrab', 
            '-i', 'desktop',
            '-framerate', '15',
            '-video_size', '1280x720',
            '-f', 'mpegts', '-',
        ]);

        ffmpeg.stdout.on('data', (data) => {
            socket.emit('screenData', data);
        });

        socket.on('mouseMove', (data) => {
            robot.moveMouse(data.x, data.y);
        });

        socket.on('keyPress', (keys) => {
            keys.forEach((key) => {
                robot.keyTap(key);
            });
        });

        socket.on('disconnect', () => {
            console.log('User disconnected:', socket.id);
            ffmpeg.kill('SIGINT');
        });
    });
};
