const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { protect } = require('../middleware/auth');

router.post('/apply-driver', protect, userController.applyAsDriver);

router.get('/me', protect, userController.getMe);
router.put('/profile', protect, userController.updateProfile);

module.exports = router;
