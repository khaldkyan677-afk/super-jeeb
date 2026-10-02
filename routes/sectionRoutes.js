const express = require('express');
const router = express.Router();
const { getSections, createSection } = require('../controllers/sectionController');
const { protect, authorize } = require('../middleware/auth');
router.route('/').get(getSections).post(protect, authorize('admin'), createSection);
module.exports = router;
