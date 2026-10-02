const Order = require('../models/Order');

// إنشاء طلب جديد (العميل)
exports.createOrder = async (req, res) => {
  try {
    const { merchantId, items, total } = req.body;
    const order = await Order.create({
      clientId: req.user._id,
      merchantId,
      items,
      total,
      pin: Math.floor(1000 + Math.random() * 9000).toString()
    });
    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// طلبات العميل
exports.getMyOrders = async (req, res) => {
  try {
    const orders = await Order.find({ clientId: req.user._id }).sort({ createdAt: -1 });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// طلبات التاجر
exports.getMerchantOrders = async (req, res) => {
  try {
    const merchantId = req.user._id;
    const orders = await Order.find({ merchantId })
      .populate('clientId', 'name phone email')
      .populate('driverId', 'name phone')
      .sort({ createdAt: -1 });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// طلبات المندوب
exports.getDriverOrders = async (req, res) => {
  try {
    const driverId = req.user._id;
    const orders = await Order.find({ driverId })
      .populate('clientId', 'name phone')
      .populate('merchantId', 'name phone address')
      .sort({ createdAt: -1 });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// تحديث حالة الطلب
exports.updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const validStatuses = ['pending', 'accepted', 'preparing', 'ready', 'on_the_way', 'delivered', 'cancelled'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ message: 'حالة غير صحيحة' });
    }
    const update = { status };
    if (status === 'delivered') update.deliveredAt = new Date();
    const order = await Order.findByIdAndUpdate(req.params.id, update, { new: true });
    if (!order) return res.status(404).json({ message: 'الطلب غير موجود' });
    res.json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// تعيين مندوب للطلب
exports.assignDriver = async (req, res) => {
  try {
    const { driverId } = req.body;
    const order = await Order.findByIdAndUpdate(
      req.params.id,
      { driverId, status: 'on_the_way' },
      { new: true }
    );
    if (!order) return res.status(404).json({ message: 'الطلب غير موجود' });
    res.json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// الطلبات المتاحة للمندوب (pending + ready)
exports.getRecentOrders = async (req, res) => {
  try {
    const orders = await Order.find({
      status: { $in: ['pending', 'ready'] },
      driverId: null
    })
      .populate('merchantId', 'name phone address')
      .sort({ createdAt: -1 })
      .limit(20);
    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// قبول الطلب من المندوب
exports.acceptOrder = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ message: 'الطلب غير موجود' });
    if (order.driverId) return res.status(400).json({ message: 'الطلب مقبول مسبقاً' });
    let driverId = req.user?._id || req.body?.driverId;
    if (!driverId) {
      const User = require('../models/User');
      const d = await User.findOne({ role: 'driver' });
      if (d) driverId = d._id;
    }
    if (!driverId) return res.status(400).json({ message: 'لا يوجد مندوب' });
    const updated = await Order.findByIdAndUpdate(
      req.params.id,
      { driverId, status: 'on_the_way' },
      { new: true }
    );
    res.json(updated);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// رفض الطلب من المندوب
exports.rejectOrder = async (req, res) => {
  try {
    const updated = await Order.findByIdAndUpdate(
      req.params.id,
      { status: 'cancelled' },
      { new: true }
    );
    if (!updated) return res.status(404).json({ message: 'الطلب غير موجود' });
    res.json(updated);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// تحديث مرحلة الرحلة (للمندوب)
exports.updateTripStage = async (req, res) => {
  try {
    const { stage } = req.body;
    const valid = ['accepted', 'preparing', 'ready', 'on_the_way', 'delivered'];
    if (!valid.includes(stage)) {
      return res.status(400).json({ message: 'مرحلة غير صحيحة' });
    }
    const update = { status: stage };
    if (stage === 'delivered') update.deliveredAt = new Date();
    const updated = await Order.findByIdAndUpdate(
      req.params.id,
      update,
      { new: true }
    );
    if (!updated) return res.status(404).json({ message: 'الطلب غير موجود' });
    res.json(updated);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
