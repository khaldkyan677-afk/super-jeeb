const mongoose = require('mongoose');
const districtSchema = new mongoose.Schema({
  cityId: { type: mongoose.Schema.Types.ObjectId, ref: 'City', required: true },
  name: { type: String, required: true },
  currency: { type: String },
  lat: { type: Number },
  lng: { type: Number }
});
module.exports = mongoose.model('District', districtSchema);
