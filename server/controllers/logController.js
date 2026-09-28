const AuditLog = require('../models/AuditLog');
const LoginLog = require('../models/LoginLog');
const ErrorLog = require('../models/ErrorLog');
const NotificationLog = require('../models/NotificationLog');

// ═══════════════ سجلات التدقيق ═══════════════

exports.listAuditLogs = async (req, res) => {
  try {
    const filter = {};
    if (req.query.userId) filter.userId = req.query.userId;
    if (req.query.action) filter.action = req.query.action;
    if (req.query.entity) filter.entity = req.query.entity;
    const list = await AuditLog.find(filter)
      .populate('userId', 'name phone email role')
      .sort({ createdAt: -1 })
      .limit(parseInt(req.query.limit) || 200);
    res.json(list);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// ═══════════════ سجلات الدخول ═══════════════

exports.listLoginLogs = async (req, res) => {
  try {
    const filter = {};
    if (req.query.userId) filter.userId = req.query.userId;
    if (req.query.success) filter.success = req.query.success === 'true';
    const list = await LoginLog.find(filter)
      .populate('userId', 'name phone email role')
      .sort({ createdAt: -1 })
      .limit(parseInt(req.query.limit) || 200);
    res.json(list);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// ═══════════════ سجلات الأخطاء ═══════════════

exports.listErrorLogs = async (req, res) => {
  try {
    const filter = {};
    if (req.query.level) filter.level = req.query.level;
    const list = await ErrorLog.find(filter)
      .sort({ createdAt: -1 })
      .limit(parseInt(req.query.limit) || 200);
    res.json(list);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// ═══════════════ سجلات الإشعارات ═══════════════

exports.listNotificationLogs = async (req, res) => {
  try {
    const filter = {};
    if (req.user.role !== 'admin') filter.userId = req.user._id;
    if (req.query.userId && req.user.role === 'admin') filter.userId = req.query.userId;
    if (req.query.status) filter.status = req.query.status;
    const list = await NotificationLog.find(filter)
      .populate('userId', 'name phone email role')
      .sort({ createdAt: -1 })
      .limit(parseInt(req.query.limit) || 200);
    res.json(list);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// ═══════════════ إحصائيات عامة ═══════════════

exports.logsStats = async (req, res) => {
  try {
    const today = new Date(); today.setHours(0,0,0,0);
    const [audit, logins, errors, notifications] = await Promise.all([
      AuditLog.countDocuments({ createdAt: { $gte: today } }),
      LoginLog.countDocuments({ createdAt: { $gte: today } }),
      ErrorLog.countDocuments({ createdAt: { $gte: today } }),
      NotificationLog.countDocuments({ createdAt: { $gte: today } }),
    ]);
    res.json({ audit, logins, errors, notifications });
  } catch (e) { res.status(500).json({ message: e.message }); }
};
