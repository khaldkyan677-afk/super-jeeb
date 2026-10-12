require('../models/User');
const Merchant = require('../models/Merchant');

exports.getAllMerchants = async (req, res) => {
  try {
    const list = await Merchant.find({ isActive: true });
    res.json(list);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getMerchantById = async (req, res) => {
  try {
    const m = await Merchant.findById(req.params.id);
    if (!m) return res.status(404).json({ error: 'Not found' });
    res.json(m);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getMyMerchant = async (req, res) => {
  try {
    const m = await Merchant.findOne({ userId: req.user._id });
    res.json(m);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createMerchant = async (req, res) => {
  try {
    const m = await Merchant.create({ ...req.body, userId: req.user._id });
    res.status(201).json(m);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.updateMerchant = async (req, res) => {
  try {
    const m = await Merchant.findByIdAndUpdate(req.params.id, req.body, { returnDocument: 'after' });
    if (!m) return res.status(404).json({ error: 'Not found' });
    res.json(m);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteMerchant = async (req, res) => {
  try {
    const m = await Merchant.findByIdAndDelete(req.params.id);
    if (!m) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.verifyMerchant = async (req, res) => {
  try {
    const { action, reason } = req.body;
    const update = {};
    if (action === 'accept') {
      update.verificationStatus = 'verified';
      update.isActive = true;
    } else if (action === 'reject') {
      update.verificationStatus = 'rejected';
      update.rejectionReason = reason || '';
      update.isActive = false;
    } else {
      return res.status(400).json({ error: 'Invalid action' });
    }
    const m = await Merchant.findByIdAndUpdate(req.params.id, update, { returnDocument: 'after' });
    if (!m) return res.status(404).json({ error: 'Not found' });
    if (action === 'accept') {
      const User = require('../models/User');
      await User.findByIdAndUpdate(m.userId, { role: 'merchant', status: 'approved' });
      const Store = require('../models/Store');
      const existing = await Store.findOne({ merchantId: m.userId });
      if (!existing) {
        await Store.create({
          name: m.storeName,
          merchantId: m.userId,
          category: m.category || '',
          location: m.location || {},
          isActive: true,
        });
      }
    }
    res.json(m);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getAllMerchantsAdmin = async (req, res) => {
  try {
    const filter = {};
    if (req.query.verificationStatus) filter.verificationStatus = req.query.verificationStatus;
    const list = await Merchant.find(filter)
      .populate('userId', 'name phone')
      .sort({ createdAt: -1 });
    res.json(list);
  } catch (e) { res.status(500).json({ error: e.message }); }
};
