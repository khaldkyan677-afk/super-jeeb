const mongoose = require('mongoose');
const citySchema = new mongoose.Schema({
  name: { type: String, required: true, unique: true },
  currency: { type: String, required: true },
  lat: { type: Number },
  lng: { type: Number },
  isActive: { type: Boolean, default: true }
});
module.exports = mongoose.model('City', citySchema);
