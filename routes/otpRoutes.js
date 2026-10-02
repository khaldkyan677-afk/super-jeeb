const express = require('express');
const router = express.Router();
const { sendOtp, verifyOtp, cleanupOtps } = require('../controllers/otpController');
const { protect, authorize } = require('../middleware/auth');

router.post('/send', sendOtp);
router.post('/verify', verifyOtp);
router.delete('/cleanup', protect, authorize('admin'), cleanupOtps);

module.exports = router;
