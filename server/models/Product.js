const mongoose = require('mongoose');
const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  price: { type: Number, required: true },
  oldPrice: { type: Number, default: 0 },
  imageUrl: { type: String, default: '' },
  storeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Store', required: true },
  category: { type: String, default: '' },
  description: { type: String, default: '' },
  stock: { type: Number, default: 0 },
  isAvailable: { type: Boolean, default: true },
}, { timestamps: true });
module.exports = mongoose.model('Product', productSchema);
