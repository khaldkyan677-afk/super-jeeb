const express = require('express');
const router = express.Router();
const serviceController = require('../controllers/serviceController');
const { protect } = require('../middleware/auth');

router.post('/', protect, serviceController.createService);
router.get('/pending', protect, serviceController.getPendingServices);
router.put('/:id/accept', protect, serviceController.acceptService);
router.put('/:id/complete', protect, serviceController.completeService);

module.exports = router;
