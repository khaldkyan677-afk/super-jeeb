const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { protect } = require('../middleware/auth');

router.post('/apply-driver', protect, userController.applyAsDriver);

module.exports = router;
