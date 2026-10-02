const mongoose = require('mongoose');

const couponSchema = new mongoose.Schema({
  code: { type: String, required: true, unique: true },
  description: { type: String, default: '' },
  discount: { type: Number, required: true },
  type: { type: String, enum: ['percentage', 'fixed'], default: 'percentage' },
  maxDiscount: { type: Number, default: 0 },
  minimumOrder: { type: Number, default: 0 },
  startAt: { type: Date, default: Date.now },
  expireAt: { type: Date },
  usageLimit: { type: Number, default: 1 },
  perUserLimit: { type: Number, default: 1 },
  usedCount: { type: Number, default: 0 },
  applicableSections: { type: [String], default: [] },
  applicableStores: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Store' }],
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  isActive: { type: Boolean, default: true },
}, { timestamps: true });

module.exports = mongoose.model('Coupon', couponSchema);
