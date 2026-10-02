const mongoose = require('mongoose');
const s = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  type: { type: String, required: true },
  title: { type: String, required: true },
  body: { type: String },
  channel: { type: String, enum: ['push', 'email', 'sms', 'in_app'], default: 'push' },
  status: { type: String, enum: ['pending', 'sent', 'failed', 'read'], default: 'pending' },
  error: { type: String },
  relatedTo: { type: String },
  relatedId: { type: mongoose.Schema.Types.ObjectId },
  sentAt: { type: Date }
}, { timestamps: true });
s.index({ userId: 1, createdAt: -1 });
s.index({ status: 1 });
module.exports = mongoose.model('NotificationLog', s);
