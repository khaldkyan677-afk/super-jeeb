const express = require('express');
const router = express.Router();
const { addFavorite, removeFavorite, getMyFavorites } = require('../controllers/favoriteController');
const { protect } = require('../middleware/auth');

router.get('/', protect, getMyFavorites);
router.post('/:storeId', protect, addFavorite);
router.delete('/:storeId', protect, removeFavorite);

module.exports = router;
