const mongoose = require('mongoose');
const s = new mongoose.Schema({
  name: { type: String, required: true },
  code: { type: String, required: true, unique: true },
  type: { type: String, enum: ['cash', 'wallet', 'card', 'bank'], default: 'wallet' },
  icon: { type: String, default: '' },
  provider: { type: String, default: '' },
  config: { type: Object, default: {} },
  minAmount: { type: Number, default: 0 },
  maxAmount: { type: Number, default: 0 },
  isActive: { type: Boolean, default: true },
  isDefault: { type: Boolean, default: false },
  order: { type: Number, default: 0 }
}, { timestamps: true });
module.exports = mongoose.model('PaymentMethod', s);
