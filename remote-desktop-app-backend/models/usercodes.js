const mongoose = require('mongoose')

const codeSchema = new mongoose.Schema({
  code: {
    type: String,
    trim: true,
  },
  user: {
    type: String,
    trim: true,
  },
})

// exporting our Schema
module.exports = mongoose.model('user_code', codeSchema)
