const mongoose = require('mongoose');
const chatSchema = new mongoose.Schema({
  orderId: { type: mongoose.Schema.Types.ObjectId, ref: 'Order', required: true },
  messages: [{
    senderId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    text: String,
    sentAt: { type: Date, default: Date.now }
  }],
  deletedAt: { type: Date },
  createdAt: { type: Date, default: Date.now }
});
module.exports = mongoose.model('Chat', chatSchema);
