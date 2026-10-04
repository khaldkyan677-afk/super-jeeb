const express = require('express');
const router = express.Router();
const c = require('../controllers/exchangeRateController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(c.getAllRates)
  .post(protect, authorize('admin'), c.createRate);

router.route('/:id')
  .get(c.getRateById)
  .put(protect, authorize('admin'), c.updateRate)
  .delete(protect, authorize('admin'), c.deleteRate);

module.exports = router;
