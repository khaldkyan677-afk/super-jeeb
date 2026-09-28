const mongoose = require('mongoose');
const s = new mongoose.Schema({
  withdrawalId: { type: String, required: true, unique: true },
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  amount: { type: Number, required: true },
  currency: { type: String, default: 'YER' },
  payoutAccountId: { type: mongoose.Schema.Types.ObjectId, ref: 'PayoutAccount', required: true },
  status: { type: String, enum: ['pending', 'approved', 'rejected', 'paid'], default: 'pending' },
  adminNote: { type: String },
  processedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  transactionRef: { type: String },
  requestedAt: { type: Date, default: Date.now },
  processedAt: { type: Date },
  paidAt: { type: Date }
}, { timestamps: true });
s.index({ userId: 1, createdAt: -1 });
s.index({ status: 1 });
module.exports = mongoose.model('Withdrawal', s);
