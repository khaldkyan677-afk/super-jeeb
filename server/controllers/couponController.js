const Coupon = require('../models/Coupon');

exports.getAllCoupons = async (req, res) => {
  try { res.json(await Coupon.find({ isActive: true })); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getCouponByCode = async (req, res) => {
  try {
    const c = await Coupon.findOne({ code: req.params.code, isActive: true });
    if (!c) return res.status(404).json({ error: 'Not found' });
    res.json(c);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createCoupon = async (req, res) => {
  try {
    const c = await Coupon.create({ ...req.body, createdBy: req.user._id });
    res.status(201).json(c);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.updateCoupon = async (req, res) => {
  try {
    const c = await Coupon.findByIdAndUpdate(req.params.id, req.body, { returnDocument: 'after' });
    if (!c) return res.status(404).json({ error: 'Not found' });
    res.json(c);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteCoupon = async (req, res) => {
  try {
    const c = await Coupon.findByIdAndDelete(req.params.id);
    if (!c) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.validateCoupon = async (req, res) => {
  try {
    const c = await Coupon.findOne({ code: req.params.code, isActive: true });
    if (!c) return res.status(404).json({ valid: false, error: 'Not found' });
    const now = new Date();
    if (c.startAt && now < c.startAt) return res.json({ valid: false, error: 'not_started' });
    if (c.expireAt && now > c.expireAt) return res.json({ valid: false, error: 'expired' });
    if (c.usageLimit > 0 && c.usedCount >= c.usageLimit) return res.json({ valid: false, error: 'used_up' });
    res.json({ valid: true, coupon: c });
  } catch (e) { res.status(500).json({ error: e.message }); }
};
