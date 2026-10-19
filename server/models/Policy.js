const mongoose = require('mongoose');
const policySchema = new mongoose.Schema({
  appType: { type: String, enum: ['client', 'merchant', 'driver'], required: true, default: 'client' },
  type: { type: String, enum: ['terms', 'privacy'], required: true },
  content: { type: String, required: true, default: 'سيتم إضافة النص هنا قريباً.' }
}, { timestamps: true });
policySchema.index({ appType: 1, type: 1 }, { unique: true });
module.exports = mongoose.model('Policy', policySchema);
