const express = require('express');
const router = express.Router();
const c = require('../controllers/receiptController');
const { protect, authorize } = require('../middleware/auth');
router.route('/').get(protect, authorize('admin'), c.getAllReceipts).post(protect, authorize('admin'), c.createReceipt);
router.route('/my').get(protect, c.getMyReceipts);
router.route('/:id').get(protect, c.getReceiptById).delete(protect, authorize('admin'), c.deleteReceipt);
module.exports = router;
