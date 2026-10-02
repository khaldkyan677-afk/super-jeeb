const mongoose = require('mongoose');
const s = new mongoose.Schema({
  refundId: { type: String, required: true, unique: true },
  transactionId: { type: mongoose.Schema.Types.ObjectId, ref: 'Transaction', required: true },
  orderId: { type: mongoose.Schema.Types.ObjectId, ref: 'Order' },
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  amount: { type: Number, required: true },
  currency: { type: String, default: 'YER' },
  reason: { type: String, required: true },
  status: { type: String, enum: ['pending', 'approved', 'rejected', 'processed'], default: 'pending' },
  requestedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  processedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  adminNote: { type: String },
  refundedAt: { type: Date }
}, { timestamps: true });
s.index({ userId: 1 });
s.index({ status: 1 });
module.exports = mongoose.model('Refund', s);
