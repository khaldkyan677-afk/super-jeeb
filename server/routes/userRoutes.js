const express = require('express');
const router = express.Router();
const { listUsers, approveUser, rejectUser, changeUserRole } = require('../controllers/miscController');
const { getMe, updateProfile } = require('../controllers/authController');
const { protect, authorize } = require('../middleware/auth');

// مسارات الملف الشخصي المطلوبة من فلاتر
router.get('/me', protect, getMe);
router.put('/me', protect, updateProfile);
router.put('/profile', protect, updateProfile);

// مسارات إدارة المستخدمين
router.get('/', protect, authorize('admin'), listUsers);
router.patch('/:id/approve', protect, authorize('admin'), approveUser);
router.patch('/:id/reject', protect, authorize('admin'), rejectUser);
router.patch('/:id/role', protect, authorize('admin'), changeUserRole);

module.exports = router;
