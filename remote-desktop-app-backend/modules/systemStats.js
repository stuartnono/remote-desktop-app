const os = require('os');

module.exports = (io) => {
    io.on('connection', (socket) => {
        console.log(`User connected: ${socket.id}`);
        
        // Send system stats every 5 seconds
        const statsInterval = setInterval(() => {
            const stats = {
                cpuUsage: os.loadavg(), // CPU load averages
                freeMemory: os.freemem(), // Free memory in bytes
                totalMemory: os.totalmem(), // Total memory in bytes
                uptime: os.uptime(), // Uptime in seconds
            };

            // Log stats to the console
            console.log(`CPU Load (1 min): ${stats.cpuUsage[0].toFixed(2)}`);
            console.log(`Free Memory: ${(stats.freeMemory / (1024 * 1024)).toFixed(2)} MB`);
            console.log(`Total Memory: ${(stats.totalMemory / (1024 * 1024)).toFixed(2)} MB`);
            console.log(`Uptime: ${(stats.uptime / 3600).toFixed(2)} hours\n`);
        }, 5000); // 5 seconds interval

        socket.on('disconnect', () => {
            console.log('User disconnected:', socket.id);
            clearInterval(statsInterval);
        });
    });
};
