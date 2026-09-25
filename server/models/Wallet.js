const mongoose = require('mongoose');
const walletSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
  balance: { type: Number, default: 0 },
  currency: { type: String, default: 'YER' },
  transactions: [{
    type: { type: String, enum: ['topup', 'payment', 'refund', 'transfer'] },
    amount: Number,
    description: String,
    date: { type: Date, default: Date.now }
  }]
});
module.exports = mongoose.model('Wallet', walletSchema);
