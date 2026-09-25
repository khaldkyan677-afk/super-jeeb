const mongoose = require('mongoose');
const sectionSchema = new mongoose.Schema({
  name: { type: String, required: true },
  iconName: { type: String },
  imageUrl: { type: String },
  order: { type: Number, default: 0 },
  isActive: { type: Boolean, default: true }
});
module.exports = mongoose.model('Section', sectionSchema);
