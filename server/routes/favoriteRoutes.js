const express = require('express');
const router = express.Router();
const { toggle, getMyFavorites } = require('../controllers/favoriteController');
const { protect } = require('../middleware/auth');

router.get('/', protect, getMyFavorites);
router.post('/:storeId', protect, toggle);

module.exports = router;
