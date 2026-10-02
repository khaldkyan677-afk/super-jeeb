const express = require('express');
const router = express.Router();
const c = require('../controllers/settingController');
const { protect, authorize } = require('../middleware/auth');

router.route('/')
  .get(c.getAllSettings)
  .post(protect, authorize('admin'), c.createSetting);

router.route('/group/:group')
  .get(c.getSettingsByGroup);

router.route('/:key')
  .get(c.getSettingByKey)
  .put(protect, authorize('admin'), c.updateSetting)
  .delete(protect, authorize('admin'), c.deleteSetting);

module.exports = router;
