const express = require('express');
const router = express.Router();
const {
  listAuditLogs, listLoginLogs, listErrorLogs,
  listNotificationLogs, logsStats
} = require('../controllers/logController');
const { protect, authorize } = require('../middleware/auth');

router.get('/audit', protect, authorize('admin'), listAuditLogs);
router.get('/logins', protect, authorize('admin'), listLoginLogs);
router.get('/errors', protect, authorize('admin'), listErrorLogs);
router.get('/notifications', protect, listNotificationLogs);
router.get('/stats', protect, authorize('admin'), logsStats);

module.exports = router;
