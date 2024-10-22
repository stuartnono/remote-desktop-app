const express = require('express')
const https = require('https')
const fs = require('fs')
const bodyParser = require('body-parser')
const socketIO = require('socket.io')
const rateLimit = require('express-rate-limit')
const mongoose = require('mongoose')
// Import custom modules
const authRoutes = require('./modules/auth')
const generateCode = require('./modules/getnewcode')
const shutdownRoutes = require('./modules/shutdown')
const websocketModule = require('./modules/websocket')
const systemStats = require('./modules/systemStats')

// SSL setup for HTTPS
const privateKey = fs.readFileSync('./certs/private.key', 'utf8')
const certificate = fs.readFileSync('./certs/certificate.crt', 'utf8')
const credentials = { key: privateKey, cert: certificate }

const app = express()
const server = https.createServer(credentials, app)
const io = socketIO(server)

const PORT = 5000

// Middleware
app.use(bodyParser.json())

// Rate limiter
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
})

//configs
require('dotenv').config({ path: './config/config.env' })

//connect mongoose
mongoose.connect(process.env.DATABASE, { useNewUrlParser: true })
const db = mongoose.connection

// Check connection
db.once('open', function () {
  console.log('Connected to MongoDB')
})
// Check for db errors
db.on('error', function (err) {
  console.error(err)
})

// Setup routes
authRoutes(app, authLimiter)
generateCode(app, authLimiter)
shutdownRoutes(app)

// WebSocket setup
websocketModule(io)
systemStats(io)

// Start the server
server.listen(PORT, () => {
  console.log(`Server is running securely on port ${PORT}`)
})
