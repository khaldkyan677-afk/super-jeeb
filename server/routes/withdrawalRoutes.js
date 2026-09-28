const express = require('express');
const router = express.Router();
const {
  listPayoutAccounts, addPayoutAccount, updatePayoutAccount, deletePayoutAccount,
  requestWithdrawal, myWithdrawals,
  listAllWithdrawals, processWithdrawal,
  listAllPayoutAccounts, verifyPayoutAccount
} = require('../controllers/withdrawalController');
const { protect, authorize } = require('../middleware/auth');

// حسابات الاستلام (مستخدم)
router.get('/accounts', protect, listPayoutAccounts);
router.post('/accounts', protect, addPayoutAccount);
router.patch('/accounts/:id', protect, updatePayoutAccount);
router.delete('/accounts/:id', protect, deletePayoutAccount);

// طلبات السحب (مستخدم)
router.post('/request', protect, requestWithdrawal);
router.get('/my', protect, myWithdrawals);

// أدمن
router.get('/admin/all', protect, authorize('admin'), listAllWithdrawals);
router.patch('/admin/:id/process', protect, authorize('admin'), processWithdrawal);
router.get('/admin/accounts', protect, authorize('admin'), listAllPayoutAccounts);
router.patch('/admin/accounts/:id/verify', protect, authorize('admin'), verifyPayoutAccount);

module.exports = router;
