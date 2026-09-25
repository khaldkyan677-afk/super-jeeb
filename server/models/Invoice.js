const mongoose = require('mongoose');
const invoiceSchema = new mongoose.Schema({
  orderId: { type: mongoose.Schema.Types.ObjectId, ref: 'Order', required: true },
  breakdown: { subtotal: Number, delivery: Number, discount: Number, total: Number },
  paymentMethod: { type: String, enum: ['cash', 'card', 'wallet'], default: 'cash' },
  status: { type: String, enum: ['unpaid', 'paid', 'refunded'], default: 'unpaid' },
  issuedAt: { type: Date, default: Date.now },
  paidAt: { type: Date }
});
module.exports = mongoose.model('Invoice', invoiceSchema);
