const express = require('express');
const router = express.Router();
const {
  getStores, getStoresBySection, createStore,
  getAllStoresAdmin, updateStore, deleteStore
} = require('../controllers/storeController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(getStores)
  .post(protect, authorize('admin', 'merchant'), createStore);

router.route('/all')
  .get(protect, authorize('admin'), getAllStoresAdmin);

router.route('/section/:sectionId')
  .get(getStoresBySection);

router.route('/:id')
  .put(protect, authorize('admin', 'merchant'), updateStore)
  .delete(protect, authorize('admin'), deleteStore);

module.exports = router;
