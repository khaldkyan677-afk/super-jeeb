const mongoose = require('mongoose');
const reportSchema = new mongoose.Schema({
  fromUserId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  againstUserId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  storeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Store' },
  orderId: { type: mongoose.Schema.Types.ObjectId, ref: 'Order' },
  reasonType: { type: String, required: true },
  reason: { type: String },
  imageUrl: { type: String },
  status: { type: String, enum: ['pending', 'reviewed', 'resolved', 'ignored'], default: 'pending' },
  createdAt: { type: Date, default: Date.now }
});
module.exports = mongoose.model('Report', reportSchema);
