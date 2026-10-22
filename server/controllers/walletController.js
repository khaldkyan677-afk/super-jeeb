const Wallet = require('../models/Wallet');
const Transaction = require('../models/Transaction');

exports.getMyWallet = async (req, res) => {
  try {
    let wallet = await Wallet.findOne({ userId: req.user._id });
    if (!wallet) wallet = await Wallet.create({ userId: req.user._id });
    res.json(wallet);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

exports.requestTopup = async (req, res) => {
  try {
    const { amount, method, notes } = req.body;
    const numAmount = Number(amount);
    if (!numAmount || numAmount <= 0) {
      return res.status(400).json({ message: 'المبلغ المدخل غير صحيح' });
    }

    const tx = await Transaction.create({
      userId: req.user._id,
      amount: numAmount,
      type: 'settlement',
      description: `طلب شحن محفظة - طريقة الدفع: ${method || 'تحويل'} - ${notes || ''}`,
      status: 'pending'
    });

    res.status(201).json({
      message: 'تم إرسال طلب الشحن بنجاح وهو قيد التدقيق والموافقة',
      transaction: tx
    });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

exports.getTransactions = async (req, res) => {
  try {
    const list = await Transaction.find({ userId: req.user._id }).sort({ createdAt: -1 });
    res.json(list);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};
