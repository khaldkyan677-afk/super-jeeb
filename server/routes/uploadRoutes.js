const express = require('express');
const router = express.Router();
const c = require('../controllers/uploadController');
const { protect } = require('../middleware/auth');

router.post('/', protect, c.uploadSingle, c.handleUpload);

module.exports = router;
