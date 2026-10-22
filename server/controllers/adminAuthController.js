const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const User = require('../models/User');

exports.adminLogin = async (req, res) => {
  try {
    const { phone, email, password } = req.body;
    
    const masterEmail = process.env.ADMIN_EMAIL || 'khaled20010405@gmail.com';
    const masterPass = process.env.ADMIN_PASSWORD || 'SJ2026KHALED';
    const masterPhone = process.env.ADMIN_PHONE || 'KHALED#SJ#ADMIN';

    const isMasterMatch = (email === masterEmail || phone === masterPhone) && password === masterPass;

    let admin = null;
    if (email) admin = await User.findOne({ email });
    if (!admin && phone) admin = await User.findOne({ phone });

    // إنشاء حساب أدمن رسمي في قاعدة البيانات إذا لم يكن موجوداً
    if (!admin && isMasterMatch) {
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(masterPass, salt);
      admin = await User.create({
        name: 'Super Admin',
        email: masterEmail,
        phone: masterPhone,
        password: hashedPassword,
        role: 'admin',
        status: 'approved',
        isActive: true
      });
    }

    if (!admin) {
      return res.status(401).json({ message: 'بيانات دخول الأدمن غير صحيحة' });
    }

    if (admin.role !== 'admin') {
      return res.status(403).json({ message: 'ليس لديك صلاحيات الأدمن' });
    }

    // مطابقة كلمة المرور
    let isMatch = false;
    if (isMasterMatch) {
      isMatch = true;
    } else if (admin.password) {
      isMatch = await bcrypt.compare(password, admin.password);
    }

    if (!isMatch) {
      return res.status(401).json({ message: 'بيانات دخول الأدمن غير صحيحة' });
    }

    // توليد التوكن بمعرف حقيقي نظامي من MongoDB
    const token = jwt.sign(
      { id: admin._id, role: 'admin' },
      process.env.JWT_SECRET,
      { expiresIn: '30d' }
    );

    res.json({
      _id: admin._id,
      name: admin.name,
      email: admin.email,
      phone: admin.phone,
      role: 'admin',
      token
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
