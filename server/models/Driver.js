const mongoose = require('mongoose');
const driverSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  vehicle: { type: String, required: true },
  license: { type: String },
  lat: { type: Number },
  lng: { type: Number },
  isAvailable: { type: Boolean, default: false },
  rating: { type: Number, default: 5 },
  earnings: { type: Number, default: 0 },
  createdAt: { type: Date, default: Date.now }
});
module.exports = mongoose.model('Driver', driverSchema);
