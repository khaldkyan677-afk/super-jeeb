const User = require('../models/User');
const Wallet = require('../models/Wallet');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '30d' });
};

exports.register = async (req, res) => {
  try {
    const { name, email, phone, password, role } = req.body;
    const userExists = await User.findOne({ $or: [{ email }, { phone }] });
    if (userExists) return res.status(400).json({ message: 'المستخدم موجود مسبقاً' });

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = await User.create({ name, email, phone, password: hashedPassword, role: role || 'client' });
    await Wallet.create({ userId: user._id, balance: 0 });

    res.status(201).json({
      _id: user._id, name: user.name, email: user.email, phone: user.phone,
      role: user.role, token: generateToken(user._id)
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) return res.status(401).json({ message: 'بيانات الدخول غير صحيحة' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ message: 'بيانات الدخول غير صحيحة' });

    if (user.role !== 'admin' && user.status !== 'approved') {
      const msg = user.status === 'rejected'
        ? 'تم رفض حسابك. تواصل مع الدعم'
        : 'حسابك قيد المراجعة. سيتم إشعارك عند الموافقة';
      return res.status(403).json({ message: msg, status: user.status });
    }

    res.json({
      _id: user._id, name: user.name, email: user.email, phone: user.phone,
      role: user.role, token: generateToken(user._id)
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


exports.firebaseLogin = async (req, res) => {
  try {
    const { email, uid, name, phone } = req.body;
    if (!email) return res.status(400).json({ message: 'البريد مطلوب' });

    let user = await User.findOne({ email });
    if (!user) {
      user = await User.create({
        name: name || email.split('@')[0],
        email,
        phone: phone || uid || email,
        password: uid || 'firebase_' + Date.now(),
        role: 'client',
        status: 'pending',
      });
    }

    if (user.role !== 'admin' && user.status !== 'approved') {
      const msg = user.status === 'rejected'
        ? 'تم رفض حسابك. تواصل مع الدعم'
        : 'حسابك قيد المراجعة. سيتم إشعارك عند الموافقة';
      return res.status(403).json({ message: msg, status: user.status });
    }

    res.json({
      id: user._id, name: user.name, email: user.email, phone: user.phone,
      role: user.role, status: user.status,
      token: generateToken(user._id),
    });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

exports.getMe = async (req, res) => {
  res.json(req.user);
};
