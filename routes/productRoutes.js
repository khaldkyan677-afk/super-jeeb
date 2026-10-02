const express = require('express');
const router = express.Router();
const { getProductsByStore, getProductById } = require('../controllers/productController');
const { addProduct, updateProduct, deleteProduct } = require('../controllers/miscController');
const { protect, authorize } = require('../middleware/auth');

router.route('/store/:storeId').get(getProductsByStore);
router.route('/:id').get(getProductById);

router.post('/', protect, authorize('merchant', 'admin'), addProduct);
router.patch('/:id', protect, authorize('merchant', 'admin'), updateProduct);
router.delete('/:id', protect, authorize('merchant', 'admin'), deleteProduct);

module.exports = router;
