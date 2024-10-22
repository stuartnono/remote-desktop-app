const { exec } = require('child_process')
var randomize = require('randomatic')
const { authenticateToken } = require('./auth')

module.exports = (app) => {
  // get new connection code
  app.get('/getcode', authenticateToken, (req, res) => {
    const code = randomize('A0', 12)
    randomize.isCrypto
    res.json({ code })
  })

  // add pin
  app.post('/pincode', authenticateToken, (req, res) => {
    req.body
    res.json({ pin: req.body })
  })
}
