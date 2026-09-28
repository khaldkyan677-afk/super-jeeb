const mongoose = require('mongoose');
const s = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  phone: { type: String },
  email: { type: String },
  method: { type: String, enum: ['otp', 'password', 'google', 'firebase'], default: 'otp' },
  success: { type: Boolean, default: true },
  failureReason: { type: String },
  ip: { type: String },
  userAgent: { type: String }
}, { timestamps: true });
s.index({ createdAt: -1 });
s.index({ userId: 1 });
module.exports = mongoose.model('LoginLog', s);
