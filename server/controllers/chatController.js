const Chat = require('../models/Chat');
exports.getChat = async (req, res) => { try { const chat = await Chat.findOne({ orderId: req.params.orderId }); res.json(chat || { messages: [] }); } catch (e) { res.status(500).json({ message: e.message }); } };
exports.sendMessage = async (req, res) => { try { const { orderId, text } = req.body; let chat = await Chat.findOne({ orderId }); if (!chat) chat = new Chat({ orderId, messages: [] }); chat.messages.push({ senderId: req.user._id, text }); await chat.save(); res.json(chat); } catch (e) { res.status(500).json({ message: e.message }); } };
