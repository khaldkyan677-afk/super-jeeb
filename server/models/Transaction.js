const mongoose = require('mongoose');
const s = new mongoose.Schema({
  transactionId: { type: String, required: true, unique: true },
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  orderId: { type: mongoose.Schema.Types.ObjectId, ref: 'Order' },
  type: { type: String, enum: ['payment', 'refund', 'withdrawal', 'topup', 'commission', 'payout'], required: true },
  method: { type: String, required: true },
  amount: { type: Number, required: true },
  currency: { type: String, default: 'YER' },
  status: { type: String, enum: ['pending', 'success', 'failed', 'cancelled', 'refunded'], default: 'pending' },
  idempotencyKey: { type: String, unique: true, sparse: true },
  gatewayRef: { type: String },
  gatewayResponse: { type: Object },
  failureReason: { type: String },
  paidAt: { type: Date }
}, { timestamps: true });
s.index({ userId: 1, createdAt: -1 });
s.index({ orderId: 1 });
module.exports = mongoose.model('Transaction', s);
