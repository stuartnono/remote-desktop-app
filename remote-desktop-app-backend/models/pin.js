const mongoose = require('mongoose')

const pinSchema = new mongoose.Schema({
  pincode: {
    type: String,
    trim: true,
  },
  user: {
    type: String,
    trim: true,
  },
})

// exporting our Schema
module.exports = mongoose.model('user_pin', pinSchema)
