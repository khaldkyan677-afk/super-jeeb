const Notification = require('../models/Notification');
exports.getMyNotifications = async (req, res) => { try { const notifs = await Notification.find({ userId: req.user._id }).sort({ createdAt: -1 }); res.json(notifs); } catch (e) { res.status(500).json({ message: e.message }); } };
exports.markAsRead = async (req, res) => { try { await Notification.findByIdAndUpdate(req.params.id, { isRead: true }); res.json({ message: 'Marked as read' }); } catch (e) { res.status(500).json({ message: e.message }); } };
exports.sendNotification = async (req, res) => { try { const notif = await Notification.create(req.body); res.status(201).json(notif); } catch (e) { res.status(500).json({ message: e.message }); } };
