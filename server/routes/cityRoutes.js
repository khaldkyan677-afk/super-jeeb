const express = require('express');
const router = express.Router();
const c = require('../controllers/cityController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(c.getAllCities)
  .post(protect, authorize('admin'), c.createCity);

router.route('/:id')
  .get(c.getCityById)
  .put(protect, authorize('admin'), c.updateCity)
  .delete(protect, authorize('admin'), c.deleteCity);

module.exports = router;
