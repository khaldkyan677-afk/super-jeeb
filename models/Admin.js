const mongoose = require('mongoose');

const adminSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  role: { type: String, enum: ['super_admin', 'admin', 'moderator', 'support'], default: 'admin' },
  permissions: { type: [String], default: [] },
  isActive: { type: Boolean, default: true },
  twoFactorEnabled: { type: Boolean, default: false },
  twoFactorSecret: { type: String },
  loginAttempts: { type: Number, default: 0 },
  lockedUntil: { type: Date },
  allowedIPs: { type: [String], default: [] },
  lastLogin: { type: Date },
  lastIP: { type: String },
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
}, { timestamps: true });

module.exports = mongoose.model('Admin', adminSchema);
