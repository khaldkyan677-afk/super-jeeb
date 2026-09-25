const mongoose = require('mongoose');
const storeSchema = new mongoose.Schema({
  name: { type: String, required: true },
  logoUrl: { type: String },
  coverUrl: { type: String },
  rating: { type: Number, default: 5 },
  deliveryTime: { type: String, default: '25 دقيقة' },
  deliveryFee: { type: Number, default: 0 },
  minimumOrder: { type: Number, default: 0 },
  openTime: { type: String, default: '08:00' },
  closeTime: { type: String, default: '23:00' },
  isFeatured: { type: Boolean, default: false },
  category: { type: String },
  sectionId: { type: mongoose.Schema.Types.ObjectId, ref: 'Section' },
  location: { lat: Number, lng: Number, address: String },
  isActive: { type: Boolean, default: true },
  createdAt: { type: Date, default: Date.now }
});
module.exports = mongoose.model('Store', storeSchema);
