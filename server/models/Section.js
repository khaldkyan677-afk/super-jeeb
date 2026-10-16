const mongoose = require('mongoose');
const sectionSchema = new mongoose.Schema({
  name: { type: String, required: true },
  iconName: { type: String },
  imageUrl: { type: String },
  order: { type: Number, default: 0 },
  isActive: { type: Boolean, default: true }
  parentId: { type: mongoose.Schema.Types.ObjectId, ref: 'Section', default: null },
});
module.exports = mongoose.model('Section', sectionSchema);
