const express = require('express');
const router = express.Router();
const { getAds, createAd, updateAd, deleteAd } = require('../controllers/adController');
const { protect, authorize } = require('../middleware/auth');
router.route('/').get(getAds).post(protect, authorize('admin'), createAd);
router.route('/:id').put(protect, authorize('admin'), updateAd).delete(protect, authorize('admin'), deleteAd);
module.exports = router;
