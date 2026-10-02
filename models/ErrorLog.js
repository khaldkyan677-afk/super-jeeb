const mongoose = require('mongoose');
const s = new mongoose.Schema({
  level: { type: String, enum: ['error', 'warning', 'info'], default: 'error' },
  message: { type: String, required: true },
  stack: { type: String },
  endpoint: { type: String },
  method: { type: String },
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  ip: { type: String },
  meta: { type: Object }
}, { timestamps: true });
s.index({ createdAt: -1 });
s.index({ level: 1 });
module.exports = mongoose.model('ErrorLog', s);
