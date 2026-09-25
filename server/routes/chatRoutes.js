const express = require('express');
const router = express.Router();
const { getChat, sendMessage } = require('../controllers/chatController');
const { protect } = require('../middleware/auth');
router.get('/:orderId', protect, getChat);
router.post('/', protect, sendMessage);
module.exports = router;
