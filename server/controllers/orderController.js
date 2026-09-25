const Order = require('../models/Order');

exports.createOrder = async (req, res) => {
  try {
    const { merchantId, items, total } = req.body;
    const order = await Order.create({
      customerId: req.user._id,
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

exports.getMyOrders = async (req, res) => {
  try {
    const orders = await Order.find({ customerId: req.user._id }).sort({ createdAt: -1 });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const order = await Order.findByIdAndUpdate(req.params.id, { status }, { new: true });
    res.json(order);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
