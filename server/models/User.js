const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  phone: { type: String, required: true, unique: true },
  email: { type: String, sparse: true },
  password: { type: String },
  role: { type: String, enum: ['client', 'merchant', 'driver', 'admin'], default: 'client' },
  walletBalance: { type: Number, default: 0 },
  points: { type: Number, default: 0 },
  governorate: { type: String, default: '' },
  birthDate: { type: String, default: '' },
  gender: { type: String, enum: ['male', 'female', ''], default: '' },
  profileImage: { type: String, default: '' }, // <--- الحقل السحري
  driverStatus: { type: String, enum: ['none', 'pending', 'approved', 'rejected'], default: 'none' },
  vehicleType: { type: String },
  vehicleModel: { type: String },
  plateNumber: { type: String },
  driverDocuments: { nationalId: String, license: String, vehicleRegistration: String, vehiclePhoto: String },
  driverRejectionReason: String,
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
