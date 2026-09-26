const express = require('express');
const router = express.Router();
const { getProductsByStore, getProductById } = require('../controllers/productController');

router.route('/store/:storeId').get(getProductsByStore);
router.route('/:id').get(getProductById);

module.exports = router;
