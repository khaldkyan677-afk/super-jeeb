const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, default: '' },
  price: { type: Number, required: true },
  discountPrice: { type: Number, default: 0 },
  imageUrl: { type: String },
  gallery: { type: [String], default: [] },
  storeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Store', required: true },
  section: { type: String },
  category: { type: String },
  dynamicFields: { type: Map, of: [String], default: {} },
  stock: { type: Number, default: 0 },
  isAvailable: { type: Boolean, default: true },
}, { timestamps: true });

module.exports = mongoose.model('Product', productSchema);
