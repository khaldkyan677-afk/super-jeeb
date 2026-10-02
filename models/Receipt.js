const mongoose = require('mongoose');
const s = new mongoose.Schema({
  receiptNumber: { type: String, required: true, unique: true },
  transactionId: { type: mongoose.Schema.Types.ObjectId, ref: 'Transaction', required: true },
  orderId: { type: mongoose.Schema.Types.ObjectId, ref: 'Order' },
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  amount: { type: Number, required: true },
  currency: { type: String, default: 'YER' },
  method: { type: String },
  details: { type: Object },
  issuedAt: { type: Date, default: Date.now }
}, { timestamps: true });
module.exports = mongoose.model('Receipt', s);
