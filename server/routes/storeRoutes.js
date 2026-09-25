const express = require('express');
const router = express.Router();
const { getStores, getStoresBySection, createStore } = require('../controllers/storeController');
const { protect, authorize } = require('../middleware/auth');
router.route('/').get(getStores).post(protect, authorize('admin', 'merchant'), createStore);
router.route('/section/:sectionId').get(getStoresBySection);
module.exports = router;
