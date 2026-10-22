const express = require('express');
const router = express.Router();
const { createRating } = require('../controllers/ratingController');
const { protect } = require('../middleware/auth');

router.post('/', protect, createRating);

module.exports = router;
