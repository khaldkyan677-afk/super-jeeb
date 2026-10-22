const Chat = require('../models/Chat');
const Order = require('../models/Order');

exports.getChat = async (req, res) => {
  try {
    const { orderId } = req.params;
    const order = await Order.findById(orderId);
    if (!order) return res.status(404).json({ message: 'الطلب غير موجود' });

    // التحقق من أن المستخدم طرف رسمي في الطلب أو أدمن
    const uid = req.user._id.toString();
    const isCustomer = order.customerId && order.customerId.toString() === uid;
    const isDriver = order.driverId && order.driverId.toString() === uid;
    const isMerchant = order.merchantId && order.merchantId.toString() === uid;
    const isAdmin = req.user.role === 'admin';

    if (!isCustomer && !isDriver && !isMerchant && !isAdmin) {
      return res.status(403).json({ message: 'ليس لديك صلاحية لعرض محادثة هذا الطلب' });
    }

    const chat = await Chat.findOne({ orderId });
    res.json(chat || { orderId, messages: [] });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

exports.sendMessage = async (req, res) => {
  try {
    const { orderId, text } = req.body;
    if (!text || !text.trim()) {
      return res.status(400).json({ message: 'نص الرسالة لا يمكن أن يكون فارغاً' });
    }

    const order = await Order.findById(orderId);
    if (!order) return res.status(404).json({ message: 'الطلب غير موجود' });

    // التحقق من صلاحية الإرسال
    const uid = req.user._id.toString();
    const isCustomer = order.customerId && order.customerId.toString() === uid;
    const isDriver = order.driverId && order.driverId.toString() === uid;
    const isMerchant = order.merchantId && order.merchantId.toString() === uid;
    const isAdmin = req.user.role === 'admin';

    if (!isCustomer && !isDriver && !isMerchant && !isAdmin) {
      return res.status(403).json({ message: 'ليس لديك صلاحية للمراسلة في هذا الطلب' });
    }

    let chat = await Chat.findOne({ orderId });
    if (!chat) {
      chat = new Chat({ orderId, messages: [] });
    }

    chat.messages.push({ senderId: req.user._id, text: text.trim() });
    await chat.save();
    res.json(chat);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};
