const express = require('express');
const router = express.Router();
const c = require('../controllers/invoiceController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(protect, authorize('admin'), c.getAllInvoices)
  .post(protect, authorize('admin'), c.createInvoice);

router.route('/my')
  .get(protect, c.getMyInvoices);

router.route('/:id')
  .get(protect, c.getInvoiceById)
  .delete(protect, authorize('admin'), c.deleteInvoice);

module.exports = router;
