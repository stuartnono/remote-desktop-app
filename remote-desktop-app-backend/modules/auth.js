const jwt = require('jsonwebtoken');
const secretKey = 'your-secret-key';

module.exports = (app, authLimiter) => {
    // Login route
    app.post('/login', authLimiter, (req, res) => {
        const { username, password } = req.body;
        if (username === 'user' && password === 'pass') {
            const token = jwt.sign({ username }, secretKey, { expiresIn: '1h' });
            res.json({ token });
        } else {
            res.status(401).json({ message: 'Invalid credentials' });
        }
    });
};

// Middleware to authenticate JWT
module.exports.authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) return res.status(403).send('Token is required');

    jwt.verify(token, secretKey, (err, user) => {
        if (err) return res.status(403).send('Invalid token');
        req.user = user;
        next();
    });
};
