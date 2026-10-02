const express = require('express');
const router = express.Router();
const { requestTrip, getMyTrips, acceptTrip, verifyPin } = require('../controllers/taxiController');
const { protect, authorize } = require('../middleware/auth');
router.post('/request', protect, requestTrip);
router.get('/my', protect, getMyTrips);
router.patch('/:id/accept', protect, authorize('driver'), acceptTrip);
router.post('/:id/verify-pin', protect, verifyPin);
module.exports = router;
