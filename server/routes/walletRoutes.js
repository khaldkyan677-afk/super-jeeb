const express = require('express');
const router = express.Router();
const { getMyWallet, requestTopup, getTransactions } = require('../controllers/walletController');
const { protect } = require('../middleware/auth');
router.get('/', protect, getMyWallet);
router.post('/topup', protect, requestTopup);
router.get('/transactions', protect, getTransactions);
module.exports = router;
