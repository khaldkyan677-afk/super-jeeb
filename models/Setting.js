const mongoose = require('mongoose');
const settingSchema = new mongoose.Schema({
  key: { type: String, required: true, unique: true },
  value: { type: mongoose.Schema.Types.Mixed, required: true },
  group: { type: String, default: 'general' },
  isSecret: { type: Boolean, default: false },
  description: { type: String, default: '' },
  updatedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  updatedAt: { type: Date, default: Date.now }
});
module.exports = mongoose.model('Setting', settingSchema);
