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
    const m = await Merchant.findByIdAndUpdate(req.params.id, req.body, { new: true });
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
    const m = await Merchant.findByIdAndUpdate(req.params.id, { isVerified: true }, { new: true });
    res.json(m);
  } catch (e) { res.status(500).json({ error: e.message }); }
};
