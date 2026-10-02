const mongoose = require('mongoose');

const chatSchema = new mongoose.Schema({
  type: { type: String, enum: ['order', 'support', 'direct'], default: 'order' },
  orderId: { type: mongoose.Schema.Types.ObjectId, ref: 'Order' },
  participants: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  messages: [{
    senderId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    text: { type: String },
    attachments: { type: [String], default: [] },
    sentAt: { type: Date, default: Date.now },
    readBy: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  }],
  lastMessage: { type: String },
  lastMessageAt: { type: Date },
  unreadCount: { type: Map, of: Number, default: {} },
  isClosed: { type: Boolean, default: false },
  deletedAt: { type: Date },
}, { timestamps: true });

module.exports = mongoose.model('Chat', chatSchema);
