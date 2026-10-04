
const express = require('express');
const router = express.Router();
const { listUsers, approveUser, rejectUser, changeUserRole } = require('../controllers/miscController');
const { protect, authorize } = require('../middleware/auth');

router.get('/', protect, authorize('admin'), listUsers);
router.patch('/:id/approve', protect, authorize('admin'), approveUser);
router.patch('/:id/reject', protect, authorize('admin'), rejectUser);
router.patch('/:id/role', protect, authorize('admin'), changeUserRole);

module.exports = router;
