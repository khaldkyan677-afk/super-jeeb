const Order = require('../models/Order');

function generateSecurePin() {
  let pin;
  let isWeak = true;
  const weakPatterns = ['1234','2345','3456','4567','5678','6789','9876','8765','7654','6543','5432','4321','0000','1111','2222','3333','4444','5555','6666','7777','8888','9999'];
  
  while (isWeak) {
    pin = Math.floor(1000 + Math.random() * 9000).toString();
    if (!weakPatterns.includes(pin) && !(pin[0] === pin[2] && pin[1] === pin[3])) {
      isWeak = false;
    }
  }
  return pin;
}

exports.createOrder = async (req, res) => {
  try {
    const {
      merchantId, storeId, items, total,
      deliveryFee, address, notes,
      paymentMethodId, paymentMethod, receiptImage,
    } = req.body;

    const securePin = generateSecurePin();

    const order = await Order.create({
      customerId: req.user._id,
      merchantId,
      storeId,
      items,
      total,
      deliveryFee: typeof deliveryFee === 'number' ? deliveryFee : 0,
      address: address != null ? String(address) : '',
      notes: notes != null ? String(notes) : '',
      paymentMethodId: paymentMethodId || null,
      paymentMethod: paymentMethod || 'cash',
      receiptImage: receiptImage || '',
      verificationStatus: receiptImage ? 'pending' : 'none',
      status: 'pending',
      deliveryPin: securePin,
      pin: securePin,
    });
    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getMyOrders = async (req, res) => {
  try {
    const orders = await Order.find({ customerId: req.user._id })
      .populate('storeId', 'name logoUrl rating location.address')
      .sort({ createdAt: -1 });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ message: 'الطلب غير موجود' });

    // التحقق من الصلاحية
    const uid = req.user._id.toString();
    const isDriver = order.driverId && order.driverId.toString() === uid;
    const isMerchant = order.merchantId && order.merchantId.toString() === uid;
    const isAdmin = req.user.role === 'admin';

    if (!isDriver && !isMerchant && !isAdmin) {
      return res.status(403).json({ message: 'ليس لديك صلاحية لتعديل حالة هذا الطلب' });
    }

    order.status = status;
    await order.save();
    res.json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getAllOrders = async (req, res) => {
  try {
    const filter = {};
    if (req.query.status) filter.status = req.query.status;
    if (req.query.verificationStatus) filter.verificationStatus = req.query.verificationStatus;
    const orders = await Order.find(filter)
      .populate('storeId', 'name logoUrl')
      .populate('customerId', 'name phone')
      .sort({ createdAt: -1 })
      .limit(100);
    res.json(orders);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.verifyOrder = async (req, res) => {
  try {
    const { action, reason } = req.body;
    const update = {
      verifiedBy: req.user._id,
      verifiedAt: new Date(),
    };
    if (action === 'accept') {
      update.verificationStatus = 'verified';
      update.status = 'accepted';
      update.paymentStatus = 'paid';
      update.paidAt = new Date();
    } else if (action === 'reject') {
      update.verificationStatus = 'rejected';
      update.status = 'cancelled';
      update.rejectionReason = reason || '';
      update.cancelledAt = new Date();
    } else {
      return res.status(400).json({ message: 'إجراء غير صالح' });
    }
    const order = await Order.findByIdAndUpdate(req.params.id, update, { new: true });
    if (!order) return res.status(404).json({ message: 'الطلب غير موجود' });
    res.json(order);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.getMerchantOrders = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const stores = await Store.find({ merchantId: req.user._id });
    const storeIds = stores.map(s => s._id);

    const filter = {
      $or: [
        { storeId: { $in: storeIds } },
        { merchantId: req.user._id }
      ]
    };
    if (req.query.status) filter.status = req.query.status;

    const orders = await Order.find(filter)
      .populate('storeId', 'name')
      .populate('customerId', 'name phone')
      .sort({ createdAt: -1 });

    res.json(orders);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.getDriverOrders = async (req, res) => {
  try {
    const orders = await Order.find({
      $or: [
        { driverId: req.user._id },
        { status: 'ready', driverId: null },
      ],
    })
      .populate('storeId', 'name logoUrl location.address')
      .populate('customerId', 'name phone')
      .sort({ createdAt: -1 });
    res.json(orders);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.assignDriver = async (req, res) => {
  try {
    // منع تضارب وقبول الطلب من أكثر من سائق
    const order = await Order.findOne({
      _id: req.params.id,
      driverId: null,
      status: { $in: ['accepted', 'preparing', 'ready'] }
    });

    if (!order && req.user.role !== 'admin') {
      return res.status(400).json({ message: 'عذراً، تم قبول هذا الطلب من قبل سائق آخر أو غير متاح' });
    }

    const updated = await Order.findByIdAndUpdate(
      req.params.id,
      { driverId: req.user._id, status: 'on_the_way' },
      { returnDocument: 'after' }
    );
    res.json(updated);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.deliverOrder = async (req, res) => {
  try {
    const { pin } = req.body;
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ message: 'الطلب غير موجود' });
    
    if (order.driverId?.toString() !== req.user._id.toString() && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'هذا الطلب ليس مخصصاً لك' });
    }

    const validPin = order.deliveryPin || order.pin;
    if (validPin && validPin !== pin) {
      return res.status(400).json({ message: 'كود التسليم غير صحيح' });
    }

    order.status = 'delivered';
    order.deliveredAt = new Date();
    await order.save();
    res.json(order);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.updateOrderStage = async (req, res) => {
  try {
    const { stage, pin } = req.body;
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ message: 'الطلب غير موجود' });

    const uid = req.user._id.toString();
    const isDriver = order.driverId && order.driverId.toString() === uid;
    const isMerchant = order.merchantId && order.merchantId.toString() === uid;
    const isAdmin = req.user.role === 'admin';

    if (!isDriver && !isMerchant && !isAdmin) {
      return res.status(403).json({ message: 'ليس لديك صلاحية لتعديل مرحلة هذا الطلب' });
    }

    if (stage === 'delivered') {
      if (!pin) return res.status(400).json({ message: 'كود التسليم مطلوب' });
      
      if (order.pinAttempts >= 3) {
        return res.status(403).json({ message: 'تم قفل الطلب بسبب كثرة المحاولات الخاطئة. تواصل مع الإدارة.' });
      }

      const expectedPin = order.deliveryPin || order.pin;
      if (expectedPin && expectedPin !== pin) {
        order.pinAttempts = (order.pinAttempts || 0) + 1;
        await order.save();
        return res.status(400).json({ message: `كود التسليم غير صحيح. المحاولات المتبقية: ${3 - order.pinAttempts}` });
      }
      order.status = 'delivered';
      order.deliveredAt = new Date();
    } else {
      order.status = stage;
    }

    await order.save();
    res.json(order);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
