const mongoose = require('mongoose');
const s = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  type: { type: String, enum: ['wallet', 'bank', 'cash'], required: true },
  accountName: { type: String, required: true },
  accountNumber: { type: String, required: true },
  walletProvider: { type: String },
  bankName: { type: String },
  iban: { type: String },
  isDefault: { type: Boolean, default: false },
  isVerified: { type: Boolean, default: false },
  isActive: { type: Boolean, default: true }
}, { timestamps: true });
s.index({ userId: 1 });
module.exports = mongoose.model('PayoutAccount', s);
