const Transaction = require('../models/Transaction');
const Order = require('../models/Order');
const Wallet = require('../models/Wallet');
const PaymentMethod = require('../models/PaymentMethod');
const Receipt = require('../models/Receipt');
const AuditLog = require('../models/AuditLog');

// توليد رقم معاملة فريد
function genTxId() {
  return 'TX' + Date.now() + Math.floor(1000 + Math.random() * 9000);
}

// ═══════════════ طرق الدفع ═══════════════

exports.listPaymentMethods = async (req, res) => {
  try {
    const onlyActive = req.query.active === 'true';
    const filter = onlyActive ? { isActive: true } : {};
    const methods = await PaymentMethod.find(filter).sort({ order: 1, createdAt: 1 });
    res.json(methods);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.addPaymentMethod = async (req, res) => {
  try {
    const m = await PaymentMethod.create(req.body);
    res.status(201).json(m);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.updatePaymentMethod = async (req, res) => {
  try {
    const m = await PaymentMethod.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!m) return res.status(404).json({ message: 'غير موجود' });
    res.json(m);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.deletePaymentMethod = async (req, res) => {
  try {
    await PaymentMethod.findByIdAndDelete(req.params.id);
    res.json({ message: 'تم الحذف' });
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// ═══════════════ إنشاء دفعة ═══════════════

exports.createPayment = async (req, res) => {
  try {
    const { orderId, method, amount, idempotencyKey } = req.body;
    const userId = req.user._id;

    // Idempotency: لو موجود سابقاً، نرجع نفس النتيجة
    if (idempotencyKey) {
      const existing = await Transaction.findOne({ idempotencyKey });
      if (existing) return res.json(existing);
    }

    const order = await Order.findById(orderId);
    if (!order) return res.status(404).json({ message: 'الطلب غير موجود' });

    const tx = await Transaction.create({
      transactionId: genTxId(),
      userId,
      orderId,
      type: 'payment',
      method: method || 'cash',
      amount: amount || order.total,
      status: 'pending',
      idempotencyKey
    });

    // للكاش: نعتبره مدفوع فوراً
    if (method === 'cash') {
      tx.status = 'success';
      tx.paidAt = new Date();
      await Transaction.findByIdAndUpdate(tx._id, {
        status: 'success',
        paidAt: new Date()
      });
      await Order.findByIdAndUpdate(orderId, {
        paymentMethod: 'cash',
        paymentStatus: 'paid',
        paymentTransactionId: tx._id,
        paidAt: new Date()
      });
      // إنشاء إيصال
      await Receipt.create({
        receiptNumber: 'RC' + Date.now(),
        transactionId: tx._id,
        orderId,
        userId,
        amount: tx.amount,
        method: 'cash'
      });
    }

    res.status(201).json(tx);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// ═══════════════ تأكيد الدفع (Webhook) ═══════════════

exports.confirmPayment = async (req, res) => {
  try {
    const { transactionId, gatewayRef, success } = req.body;

    const tx = await Transaction.findOne({ transactionId });
    if (!tx) return res.status(404).json({ message: 'المعاملة غير موجودة' });

    if (success) {
      await Transaction.findByIdAndUpdate(tx._id, {
        status: 'success',
        paidAt: new Date(),
        gatewayRef
      });
      if (tx.orderId) {
        await Order.findByIdAndUpdate(tx.orderId, {
          paymentStatus: 'paid',
          paidAt: new Date(),
          paymentTransactionId: tx._id
        });
      }
    } else {
      await Transaction.findByIdAndUpdate(tx._id, { status: 'failed', failureReason: gatewayRef });
    }

    res.json({ message: 'OK' });
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// ═══════════════ سجل المعاملات ═══════════════

exports.listTransactions = async (req, res) => {
  try {
    const filter = {};
    if (req.user.role !== 'admin') filter.userId = req.user._id;
    if (req.query.userId && req.user.role === 'admin') filter.userId = req.query.userId;
    if (req.query.orderId) filter.orderId = req.query.orderId;
    if (req.query.status) filter.status = req.query.status;
    if (req.query.type) filter.type = req.query.type;

    const list = await Transaction.find(filter)
      .populate('userId', 'name phone email')
      .sort({ createdAt: -1 })
      .limit(parseInt(req.query.limit) || 100);

    res.json(list);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.getTransaction = async (req, res) => {
  try {
    const tx = await Transaction.findById(req.params.id)
      .populate('userId', 'name phone')
      .populate('orderId');
    if (!tx) return res.status(404).json({ message: 'غير موجودة' });
    res.json(tx);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// ═══════════════ استرداد ═══════════════

exports.refundPayment = async (req, res) => {
  try {
    const { transactionId, reason } = req.body;
    const tx = await Transaction.findById(transactionId);
    if (!tx) return res.status(404).json({ message: 'غير موجودة' });

    const Refund = require('../models/Refund');
    const refund = await Refund.create({
      refundId: 'RF' + Date.now(),
      transactionId: tx._id,
      orderId: tx.orderId,
      userId: tx.userId,
      amount: tx.amount,
      reason: reason || 'طلب استرداد',
      status: 'pending',
      requestedBy: req.user._id
    });

    await AuditLog.create({
      userId: req.user._id,
      userRole: req.user.role,
      action: 'refund_request',
      entity: 'Transaction',
      entityId: tx._id,
      description: 'طلب استرداد - ' + tx.amount
    });

    res.status(201).json(refund);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// ═══════════════ إحصائيات الدفع (أدمن) ═══════════════

exports.paymentStats = async (req, res) => {
  try {
    const total = await Transaction.countDocuments();
    const success = await Transaction.countDocuments({ status: 'success' });
    const failed = await Transaction.countDocuments({ status: 'failed' });
    const pending = await Transaction.countDocuments({ status: 'pending' });

    const sumAgg = await Transaction.aggregate([
      { $match: { status: 'success' } },
      { $group: { _id: null, total: { $sum: '$amount' } } }
    ]);
    const totalAmount = sumAgg[0]?.total || 0;

    res.json({ total, success, failed, pending, totalAmount });
  } catch (e) { res.status(500).json({ message: e.message }); }
};
