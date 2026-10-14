const express = require('express');
const router = express.Router();
const {
  getProductsByStore, getProductById,
  createProduct, updateProduct, deleteProduct, getMyProducts,
} = require('../controllers/productController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .post(protect, authorize('merchant', 'admin'), createProduct);

router.route('/my')
  .get(protect, authorize('merchant', 'admin'), getMyProducts);

router.route('/store/:storeId').get(getProductsByStore);
router.route('/:id')
  .get(getProductById)
  .put(protect, authorize('merchant', 'admin'), updateProduct)
  .delete(protect, authorize('merchant', 'admin'), deleteProduct);

module.exports = router;
