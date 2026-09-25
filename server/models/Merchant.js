const mongoose = require('mongoose');
const merchantSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  storeName: { type: String, required: true },
  category: { type: String },
  image: { type: String },
  location: { lat: Number, lng: Number, address: String },
  isActive: { type: Boolean, default: true },
  commission: { type: Number, default: 0 },
  createdAt: { type: Date, default: Date.now }
});
module.exports = mongoose.model('Merchant', merchantSchema);
