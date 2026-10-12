const Order = require('../models/Order');

exports.createOrder = async (req, res) => {
  try {
    const { merchantId, storeId, items, total } = req.body;
    const order = await Order.create({
      customerId: req.user._id,
      merchantId,
      storeId,
      items,
      total,
      pin: Math.floor(1000 + Math.random() * 9000).toString()
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
    const order = await Order.findByIdAndUpdate(req.params.id, { status }, { returnDocument: 'after' });
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
      return res.status(400).json({ message: 'Invalid action' });
    }
    const order = await Order.findByIdAndUpdate(req.params.id, update, { new: true });
    if (!order) return res.status(404).json({ message: 'Not found' });
    res.json(order);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.getMerchantOrders = async (req, res) => {
  try {
    const Merchant = require('../models/Merchant');
    const merchant = await Merchant.findOne({ userId: req.user._id });
    if (!merchant) return res.status(404).json({ message: 'Merchant not found' });

    const Store = require('../models/Store');
    const stores = await Store.find({ merchantId: req.user._id, isActive: true });
    const storeIds = stores.map(s => s._id);

    const filter = { storeId: { $in: storeIds } };
    if (req.query.status) filter.status = req.query.status;

    const orders = await Order.find(filter)
      .populate('storeId', 'name')
      .populate('customerId', 'name phone')
      .sort({ createdAt: -1 });

    res.json(orders);
  } catch (e) { res.status(500).json({ message: e.message }); }
};
