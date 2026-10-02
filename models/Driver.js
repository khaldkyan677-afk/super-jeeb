const mongoose = require('mongoose');

const driverSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  vehicle: { type: String, required: true },
  vehicleType: { type: String, enum: ['motorcycle', 'car', 'bicycle', 'foot'], default: 'motorcycle' },
  license: { type: String },
  city: { type: String },
  lat: { type: Number },
  lng: { type: Number },
  isAvailable: { type: Boolean, default: false },
  isActive: { type: Boolean, default: true },
  isVerified: { type: Boolean, default: false },
  rating: { type: Number, default: 5 },
  ratingCount: { type: Number, default: 0 },
  earnings: { type: Number, default: 0 },
  wallet: { type: Number, default: 0 },
  commission: { type: Number, default: 0 },
  totalTrips: { type: Number, default: 0 },
  totalDeliveries: { type: Number, default: 0 },
  payoutAccount: {
    method: { type: String },
    accountNumber: { type: String },
    accountName: { type: String },
  },
  documents: {
    idCard: { type: String },
    licenseImage: { type: String },
  },
}, { timestamps: true });

module.exports = mongoose.model('Driver', driverSchema);
