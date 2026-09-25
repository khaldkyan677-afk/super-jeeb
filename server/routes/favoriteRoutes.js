const express = require('express');
const router = express.Router();
const { toggle, getMyFavorites } = require('../controllers/favoriteController');

router.get('/', getMyFavorites);
router.post('/:storeId', toggle);
module.exports = router;
