const express = require('express');
const router = express.Router();
const c = require('../controllers/adminController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(protect, authorize('admin'), c.getAllAdmins)
  .post(protect, authorize('admin'), c.createAdmin);

router.route('/:id')
  .get(protect, authorize('admin'), c.getAdminById)
  .put(protect, authorize('admin'), c.updateAdmin)
  .delete(protect, authorize('admin'), c.deleteAdmin);

router.route('/:id/unlock')
  .patch(protect, authorize('admin'), c.unlockAdmin);

module.exports = router;
