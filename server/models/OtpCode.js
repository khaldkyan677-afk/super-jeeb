const mongoose = require('mongoose');
const s = new mongoose.Schema({
  phone: { type: String, required: true, index: true },
  code: { type: String, required: true },
  purpose: { type: String, enum: ['login', 'register', 'payment', 'withdrawal', 'verify'], required: true },
  attempts: { type: Number, default: 0 },
  maxAttempts: { type: Number, default: 5 },
  expiresAt: { type: Date, required: true },
  isUsed: { type: Boolean, default: false },
  ip: { type: String }
}, { timestamps: true });
s.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });
module.exports = mongoose.model('OtpCode', s);
