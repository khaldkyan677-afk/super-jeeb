const express = require('express');
const router = express.Router();
const {
  getSections, getAllSections, createSection,
  updateSection, deleteSection
} = require('../controllers/sectionController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(getSections)
  .post(protect, authorize('admin'), createSection);

router.route('/all')
  .get(protect, authorize('admin'), getAllSections);

router.route('/:id')
  .put(protect, authorize('admin'), updateSection)
  .delete(protect, authorize('admin'), deleteSection);

module.exports = router;
