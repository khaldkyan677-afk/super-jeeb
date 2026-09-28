const mongoose = require('mongoose');
const s = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  userRole: { type: String },
  action: { type: String, required: true },
  entity: { type: String },
  entityId: { type: mongoose.Schema.Types.ObjectId },
  before: { type: Object },
  after: { type: Object },
  ip: { type: String },
  userAgent: { type: String },
  description: { type: String }
}, { timestamps: true });
s.index({ createdAt: -1 });
s.index({ userId: 1 });
module.exports = mongoose.model('AuditLog', s);
