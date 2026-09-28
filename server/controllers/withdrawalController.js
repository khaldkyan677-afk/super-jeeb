const PayoutAccount = require('../models/PayoutAccount');
const Withdrawal = require('../models/Withdrawal');
const Wallet = require('../models/Wallet');
const AuditLog = require('../models/AuditLog');

function genWid() { return 'WD' + Date.now() + Math.floor(1000 + Math.random() * 9000); }

// ═══════════════ حسابات الاستلام ═══════════════

exports.listPayoutAccounts = async (req, res) => {
  try {
    const accounts = await PayoutAccount.find({ userId: req.user._id }).sort({ isDefault: -1, createdAt: -1 });
    res.json(accounts);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.addPayoutAccount = async (req, res) => {
  try {
    const { type, accountName, accountNumber, walletProvider, bankName, iban, isDefault } = req.body;
    if (!type || !accountName || !accountNumber) {
      return res.status(400).json({ message: 'البيانات ناقصة' });
    }
    // إذا isDefault، نلغي default من البقية
    if (isDefault) {
      await PayoutAccount.updateMany({ userId: req.user._id }, { isDefault: false });
    }
    const acc = await PayoutAccount.create({
      userId: req.user._id,
      type, accountName, accountNumber,
      walletProvider, bankName, iban,
      isDefault: !!isDefault
    });
    res.status(201).json(acc);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.updatePayoutAccount = async (req, res) => {
  try {
    const acc = await PayoutAccount.findOneAndUpdate(
      { _id: req.params.id, userId: req.user._id },
      req.body,
      { new: true }
    );
    if (!acc) return res.status(404).json({ message: 'غير موجود' });
    res.json(acc);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.deletePayoutAccount = async (req, res) => {
  try {
    await PayoutAccount.findOneAndDelete({ _id: req.params.id, userId: req.user._id });
    res.json({ message: 'تم الحذف' });
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// ═══════════════ طلبات السحب ═══════════════

exports.requestWithdrawal = async (req, res) => {
  try {
    const { amount, payoutAccountId } = req.body;
    const userId = req.user._id;

    if (!amount || amount <= 0) return res.status(400).json({ message: 'المبلغ غير صحيح' });

    const acc = await PayoutAccount.findOne({ _id: payoutAccountId, userId });
    if (!acc) return res.status(404).json({ message: 'حساب الاستلام غير موجود' });

    // التحقق من الرصيد
    const wallet = await Wallet.findOne({ userId });
    const balance = wallet?.balance || 0;
    if (balance < amount) {
      return res.status(400).json({ message: 'الرصيد غير كافٍ. المتاح: ' + balance });
    }

    const wd = await Withdrawal.create({
      withdrawalId: genWid(),
      userId,
      amount,
      payoutAccountId,
      status: 'pending'
    });

    await AuditLog.create({
      userId,
      userRole: req.user.role,
      action: 'withdrawal_request',
      entity: 'Withdrawal',
      entityId: wd._id,
      description: `طلب سحب ${amount}`
    });

    res.status(201).json(wd);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.myWithdrawals = async (req, res) => {
  try {
    const list = await Withdrawal.find({ userId: req.user._id })
      .populate('payoutAccountId')
      .sort({ createdAt: -1 });
    res.json(list);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

// ═══════════════ أدمن ═══════════════

exports.listAllWithdrawals = async (req, res) => {
  try {
    const filter = {};
    if (req.query.status) filter.status = req.query.status;
    const list = await Withdrawal.find(filter)
      .populate('userId', 'name phone email role')
      .populate('payoutAccountId')
      .sort({ createdAt: -1 });
    res.json(list);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.processWithdrawal = async (req, res) => {
  try {
    const { status, adminNote, transactionRef } = req.body;
    const valid = ['approved', 'rejected', 'paid'];
    if (!valid.includes(status)) return res.status(400).json({ message: 'حالة غير صحيحة' });

    const wd = await Withdrawal.findById(req.params.id);
    if (!wd) return res.status(404).json({ message: 'غير موجود' });

    if (wd.status !== 'pending' && status !== 'paid') {
      return res.status(400).json({ message: 'لا يمكن تعديل هذا الطلب' });
    }

    const update = {
      status,
      adminNote,
      processedBy: req.user._id,
      processedAt: new Date()
    };
    if (status === 'paid') {
      update.paidAt = new Date();
      update.transactionRef = transactionRef;
      // خصم من المحفظة
      await Wallet.findOneAndUpdate(
        { userId: wd.userId },
        { $inc: { balance: -wd.amount } }
      );
    }

    const updated = await Withdrawal.findByIdAndUpdate(wd._id, update, { new: true });

    await AuditLog.create({
      userId: req.user._id,
      userRole: req.user.role,
      action: 'withdrawal_' + status,
      entity: 'Withdrawal',
      entityId: wd._id,
      description: `${status} - ${wd.amount}`
    });

    res.json(updated);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.listAllPayoutAccounts = async (req, res) => {
  try {
    const list = await PayoutAccount.find()
      .populate('userId', 'name phone email role')
      .sort({ createdAt: -1 });
    res.json(list);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.verifyPayoutAccount = async (req, res) => {
  try {
    const acc = await PayoutAccount.findByIdAndUpdate(
      req.params.id,
      { isVerified: true },
      { new: true }
    );
    res.json(acc);
  } catch (e) { res.status(500).json({ message: e.message }); }
};
