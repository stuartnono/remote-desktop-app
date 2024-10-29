const { exec } = require('child_process')
var randomize = require('randomatic')
const userCode = require('../models/usercodes')
const pinCode = require('../models/pin')
const mongoose = require('mongoose')
const { authenticateToken } = require('./auth')

module.exports = (app) => {
  // get new connection code
  app.get('/getcode', authenticateToken, async (req, res) => {
    const newCode = randomize('A0', 12)
    randomize.isCrypto

    try {
      const code = new userCode({ code: newCode })
      await code.save()
      res.json({ user_code: newCode })
    } catch (error) {
      console.log(error.message)
    }
  })

  //   // add pin
  app.post('/pincode', authenticateToken, async (req, res) => {
    try {
      const pincode = new pinCode({ pincode: req.body.pin })
      await pincode.save()
      res.json({ pin_code: req.body.pin })
    } catch (error) {
      console.log(error.message)
    }
  })
}
