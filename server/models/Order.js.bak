const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  customerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  merchantId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  driverId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  items: [{ name: String, price: Number, quantity: Number }],
  total: { type: Number, required: true },
  status: { 
    type: String, 
    enum: ['pending', 'accepted', 'preparing', 'on_the_way', 'delivered', 'cancelled'], 
    default: 'pending' 
  },
  pin: { type: String },
  createdAt: { type: Date, default: Date.now },
  deliveredAt: { type: Date }
});

module.exports = mongoose.model('Order', orderSchema);
