const express = require('express');
const router = express.Router();
const c = require('../controllers/addressController');
const { protect } = require('../middleware/auth');

router.route('/')
  .get(protect, c.getMyAddresses)
  .post(protect, c.createAddress);

router.route('/:id')
  .get(protect, c.getAddressById)
  .put(protect, c.updateAddress)
  .delete(protect, c.deleteAddress);

module.exports = router;
