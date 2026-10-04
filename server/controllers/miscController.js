const Order = require('../models/Order');
const User = require('../models/User');
const Product = require('../models/Product');

// عميل يلغي طلب
exports.cancelOrder = async (req, res) => {
  try {
    const o = await Order.findByIdAndUpdate(req.params.id, { status: 'cancelled' }, { new: true });
    if (!o) return res.status(404).json({ message: 'الطلب غير موجود' });
    res.json(o);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// تفاصيل طلب
exports.getOrderById = async (req, res) => {
  try {
    const o = await Order.findById(req.params.id)
      .populate('clientId', 'name phone')
      .populate('merchantId', 'name phone address')
      .populate('driverId', 'name phone');
    if (!o) return res.status(404).json({ message: 'الطلب غير موجود' });
    res.json(o);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// أدمن: قائمة المستخدمين
exports.listUsers = async (req, res) => {
  try {
    const filter = {};
    if (req.query.role) filter.role = req.query.role;
    if (req.query.status) filter.status = req.query.status;
    const users = await User.find(filter, 'name email phone role status createdAt').sort({ createdAt: -1 });
    res.json(users);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// أدمن: موافقة
exports.approveUser = async (req, res) => {
  try {
    const u = await User.findByIdAndUpdate(
      req.params.id,
      { status: 'approved' },
      { new: true }
    );
    if (!u) return res.status(404).json({ message: 'المستخدم غير موجود' });
    res.json(u);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// أدمن: رفض
exports.rejectUser = async (req, res) => {
  try {
    const u = await User.findByIdAndUpdate(
      req.params.id,
      { status: 'rejected' },
      { new: true }
    );
    if (!u) return res.status(404).json({ message: 'المستخدم غير موجود' });
    res.json(u);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// أدمن: تغيير دور
exports.changeUserRole = async (req, res) => {
  try {
    const { role } = req.body;
    if (!['client','merchant','driver','admin'].includes(role)) {
      return res.status(400).json({ message: 'دور غير صحيح' });
    }
    const u = await User.findByIdAndUpdate(req.params.id, { role }, { new: true });
    res.json(u);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// منتجات: إضافة
exports.addProduct = async (req, res) => {
  try {
    const { name, price, storeId, category, imageUrl } = req.body;
    const p = await Product.create({ name, price, storeId, category, imageUrl, isAvailable: true });
    res.status(201).json(p);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// منتجات: تعديل
exports.updateProduct = async (req, res) => {
  try {
    const p = await Product.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!p) return res.status(404).json({ message: 'المنتج غير موجود' });
    res.json(p);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// منتجات: حذف
exports.deleteProduct = async (req, res) => {
  try {
    const p = await Product.findByIdAndDelete(req.params.id);
    if (!p) return res.status(404).json({ message: 'المنتج غير موجود' });
    res.json({ message: 'تم الحذف', id: req.params.id });
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// أرباح المندوب
exports.driverEarnings = async (req, res) => {
  try {
    const did = req.user?._id || req.query.driverId;
    const orders = await Order.find({ driverId: did, status: 'delivered' }).sort({ deliveredAt: -1 });
    const total = orders.reduce((s, o) => s + (o.total || 0), 0);
    const today = new Date(); today.setHours(0,0,0,0);
    const todayOrders = orders.filter(o => new Date(o.deliveredAt) >= today);
    const todayTotal = todayOrders.reduce((s, o) => s + (o.total || 0), 0);
    res.json({
      total: total,
      today: todayTotal,
      count: orders.length,
      todayCount: todayOrders.length,
      orders: orders.slice(0, 20),
    });
  } catch (e) { res.status(500).json({ message: e.message }); }
};
