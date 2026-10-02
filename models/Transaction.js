const mongoose = require('mongoose');

const transactionSchema = new mongoose.Schema({
  orderId: { type: mongoose.Schema.Types.ObjectId, ref: 'Order' },
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  merchantId: { type: mongoose.Schema.Types.ObjectId, ref: 'Merchant' },
  driverId: { type: mongoose.Schema.Types.ObjectId, ref: 'Driver' },
  amount: { type: Number, required: true },
  currency: { type: String, default: 'YER' },
  method: { type: String, enum: ['cash', 'wallet', 'card', 'bank', 'kuraimi', 'amfloos', 'jawali', 'cashmoney'], default: 'cash' },
  type: { type: String, enum: ['payment', 'refund', 'topup', 'withdrawal', 'commission'], default: 'payment' },
  status: { type: String, enum: ['pending', 'success', 'failed', 'refunded', 'cancelled'], default: 'pending' },
  transactionRef: { type: String },
  gateway: { type: String },
  commission: { type: Number, default: 0 },
  merchantShare: { type: Number, default: 0 },
  driverShare: { type: Number, default: 0 },
  platformShare: { type: Number, default: 0 },
  notes: { type: String },
  paidAt: { type: Date },
  refundedAt: { type: Date },
}, { timestamps: true });

module.exports = mongoose.model('Transaction', transactionSchema);
