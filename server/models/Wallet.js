const mongoose = require('mongoose');
const walletSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
  balance: { type: Number, default: 0 }, // الرصيد (يمكن أن يكون سالباً للمديونية)
  currency: { type: String, default: 'YER' }
}, { timestamps: true });
module.exports = mongoose.model('Wallet', walletSchema);
