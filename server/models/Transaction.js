const mongoose = require('mongoose');
const transSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  amount: { type: Number, required: true },
  type: { type: String, enum: ['commission', 'settlement', 'debt', 'payout'], required: true },
  description: { type: String },
  status: { type: String, enum: ['pending', 'completed', 'rejected'], default: 'completed' }
}, { timestamps: true });
module.exports = mongoose.model('Transaction', transSchema);
