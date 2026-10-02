const mongoose = require('mongoose');

const merchantSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  storeName: { type: String, required: true },
  description: { type: String, default: '' },
  category: { type: String },
  image: { type: String },
  coverImage: { type: String },
  location: { lat: Number, lng: Number, address: String },
  openTime: { type: String, default: '08:00' },
  closeTime: { type: String, default: '22:00' },
  deliveryFee: { type: Number, default: 0 },
  minimumOrder: { type: Number, default: 0 },
  wallet: { type: Number, default: 0 },
  payoutAccount: {
    method: { type: String },
    accountNumber: { type: String },
    accountName: { type: String },
  },
  documents: {
    commercialRegister: { type: String },
    idCard: { type: String },
  },
  isVerified: { type: Boolean, default: false },
  rating: { type: Number, default: 0 },
  ratingCount: { type: Number, default: 0 },
  isActive: { type: Boolean, default: true },
  commission: { type: Number, default: 0 },
}, { timestamps: true });

module.exports = mongoose.model('Merchant', merchantSchema);
