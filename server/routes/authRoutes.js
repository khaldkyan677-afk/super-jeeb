const express = require('express');
const router = express.Router();
const { register, login, getMe, firebaseLogin } = require('../controllers/authController');
const { protect } = require('../middleware/auth');

router.post('/register', register);
router.post('/login', login);
router.post('/firebase-login', firebaseLogin);
router.get('/me', protect, getMe);

module.exports = router;
