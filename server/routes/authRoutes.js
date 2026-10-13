const express = require('express');
const router = express.Router();
const { register, login, getMe, firebaseLogin, updateProfile } = require('../controllers/authController');
const { protect } = require('../middleware/auth');

router.post('/register', register);
router.post('/login', login);
router.post('/firebase-login', firebaseLogin);
router.get('/me', protect, getMe);
router.put('/me', protect, updateProfile);

module.exports = router;
