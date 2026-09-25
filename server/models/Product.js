const mongoose = require('mongoose');
const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  price: { type: Number, required: true },
  imageUrl: { type: String },
  storeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Store', required: true },
  category: { type: String },
  isAvailable: { type: Boolean, default: true }
});
module.exports = mongoose.model('Product', productSchema);
