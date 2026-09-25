const express = require('express');
const router = express.Router();
const { createRating } = require('../controllers/ratingController');

router.post('/', createRating);
module.exports = router;
