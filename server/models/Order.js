const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  customerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  merchantId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  driverId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  items: [{ name: String, price: Number, quantity: Number }],
  total: { type: Number, required: true },
  status: { 
    type: String, 
    enum: ['pending', 'accepted', 'preparing', 'ready', 'on_the_way', 'delivered', 'cancelled'], 
    default: 'pending' 
  },
  pin: { type: String },
  createdAt: { type: Date, default: Date.now },
  deliveredAt: { type: Date },
  paymentMethod: { type: String, default: 'cash' },
  paymentStatus: { type: String, enum: ['unpaid', 'paid', 'refunded', 'failed'], default: 'unpaid' },
  paymentTransactionId: { type: mongoose.Schema.Types.ObjectId, ref: 'Transaction' },
  paidAt: { type: Date },
  commission: { type: Number, default: 0 },
  merchantShare: { type: Number, default: 0 },
  driverShare: { type: Number, default: 0 },
  platformShare: { type: Number, default: 0 },
  refundedAt: { type: Date },
  cancelledAt: { type: Date },
  cancelReason: { type: String },
  address: { type: String },
  notes: { type: String },
  paymentMethodId: { type: mongoose.Schema.Types.ObjectId, ref: 'PaymentMethod' },
  receiptImage: { type: String },
  verificationStatus: {
    type: String,
    enum: ['none', 'pending', 'verified', 'rejected'],
    default: 'none'
  },
  rejectionReason: { type: String },
  verifiedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  verifiedAt: { type: Date }
});

module.exports = mongoose.model('Order', orderSchema);
