const express = require('express');
const router = express.Router();
const tripController = require('../controllers/tripController');
const { protect } = require('../middleware/auth');

router.post('/', protect, tripController.createTrip);
router.get('/search', protect, tripController.searchTrips);
router.post('/:id/book', protect, tripController.bookTrip);

module.exports = router;
