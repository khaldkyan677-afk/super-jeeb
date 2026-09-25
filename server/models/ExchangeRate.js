const mongoose = require('mongoose');
const exchangeRateSchema = new mongoose.Schema({
  from: { type: String, required: true },
  to: { type: String, required: true },
  rate: { type: Number, required: true },
  updatedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  updatedAt: { type: Date, default: Date.now }
});
module.exports = mongoose.model('ExchangeRate', exchangeRateSchema);
