const express = require('express');
const router = express.Router();
const { getMyNotifications, markAsRead, sendNotification } = require('../controllers/notificationController');
const { protect, authorize } = require('../middleware/auth');
router.get('/', protect, getMyNotifications);
router.patch('/:id/read', protect, markAsRead);
router.post('/', protect, authorize('admin'), sendNotification);
module.exports = router;
