const express = require('express');
const router = express.Router();
const c = require('../controllers/officialAccountController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(c.getAllAccounts)
  .post(protect, authorize('admin'), c.createAccount);

router.route('/:id')
  .get(c.getAccountById)
  .put(protect, authorize('admin'), c.updateAccount)
  .delete(protect, authorize('admin'), c.deleteAccount);

module.exports = router;
