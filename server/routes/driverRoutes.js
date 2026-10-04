
const express = require('express');
const router = express.Router();
const { driverEarnings } = require('../controllers/miscController');
const { protect } = require('../middleware/auth');

router.get('/earnings', protect, driverEarnings);

module.exports = router;
