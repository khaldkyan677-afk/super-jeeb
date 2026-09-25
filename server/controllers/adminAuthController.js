const jwt = require('jsonwebtoken');

exports.adminLogin = async (req, res) => {
  const { phone, email, password } = req.body;
  if (phone === 'KHALED#SJ#ADMIN' && email === 'khaled20010405@gmail.com' && password === 'SJ2026KHALED') {
    const token = jwt.sign({ id: 'admin_master', role: 'admin' }, process.env.JWT_SECRET, { expiresIn: '30d' });
    return res.json({ _id: 'admin_master', name: 'Admin', email, role: 'admin', token });
  }
  return res.status(401).json({ message: 'بيانات دخول الأدمن غير صحيحة' });
};
