const mongoose = require('mongoose');
const ratingSchema = new mongoose.Schema({
  orderId: { type: mongoose.Schema.Types.ObjectId, ref: 'Order' },
  fromUserId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  toUserId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  storeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Store' },
  stars: { type: Number, min: 1, max: 5, required: true },
  feedback: { type: String },
  imageUrl: { type: String },
  createdAt: { type: Date, default: Date.now }
});
ratingSchema.index({ fromUserId: 1, storeId: 1 }, { unique: true, sparse: true });
module.exports = mongoose.model('Rating', ratingSchema);
