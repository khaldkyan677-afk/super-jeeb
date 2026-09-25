const mongoose = require('mongoose');
const storeSchema = new mongoose.Schema({
  name: { type: String, required: true },
  imageUrl: { type: String },
  rating: { type: Number, default: 5 },
  deliveryTime: { type: String },
  isFeatured: { type: Boolean, default: false },
  sectionId: { type: mongoose.Schema.Types.ObjectId, ref: 'Section' },
  location: { lat: Number, lng: Number, address: String },
  isActive: { type: Boolean, default: true }
});
module.exports = mongoose.model('Store', storeSchema);
