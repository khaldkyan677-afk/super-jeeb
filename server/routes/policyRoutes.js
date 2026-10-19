const express = require('express');
const router = express.Router();
const policyController = require('../controllers/policyController');
const { protect, authorize } = require('../middleware/auth');

// الجميع (عميل، تاجر، مندوب) يمكنهم القراءة
router.get('/:appType/:type', policyController.getPolicy);

// الأدمن فقط هو من يملك صلاحية التعديل
router.put('/:appType/:type', protect, authorize('admin'), policyController.updatePolicy);

module.exports = router;
