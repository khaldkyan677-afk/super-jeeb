const express = require('express');
const router = express.Router();
const c = require('../controllers/districtController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(c.getAllDistricts)
  .post(protect, authorize('admin'), c.createDistrict);

router.route('/city/:cityId')
  .get(c.getDistrictsByCity);

router.route('/:id')
  .get(c.getDistrictById)
  .put(protect, authorize('admin'), c.updateDistrict)
  .delete(protect, authorize('admin'), c.deleteDistrict);

module.exports = router;
