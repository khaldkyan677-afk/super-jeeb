const express = require('express');
const router = express.Router();
const {
  listPaymentMethods, addPaymentMethod, updatePaymentMethod, deletePaymentMethod,
  createPayment, confirmPayment, listTransactions, getTransaction,
  refundPayment, paymentStats
} = require('../controllers/paymentController');
const { protect, authorize } = require('../middleware/auth');

router.get('/methods', listPaymentMethods);
router.post('/methods', protect, authorize('admin'), addPaymentMethod);
router.patch('/methods/:id', protect, authorize('admin'), updatePaymentMethod);
router.delete('/methods/:id', protect, authorize('admin'), deletePaymentMethod);

router.post('/create', protect, createPayment);
router.post('/confirm', confirmPayment);

router.get('/transactions', protect, listTransactions);
router.get('/transactions/:id', protect, getTransaction);

router.post('/refund', protect, authorize('admin'), refundPayment);
router.get('/stats', protect, authorize('admin'), paymentStats);

module.exports = router;
