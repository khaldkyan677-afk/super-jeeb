const Refund = require('../models/Refund');

exports.getMyRefunds = async (req, res) => {
  try { res.json(await Refund.find({ userId: req.user._id })); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getAllRefunds = async (req, res) => {
  try { res.json(await Refund.find({})); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createRefund = async (req, res) => {
  try { res.status(201).json(await Refund.create(req.body)); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.updateRefundStatus = async (req, res) => {
  try {
    const r = await Refund.findByIdAndUpdate(req.params.id, { status: req.body.status }, { new: true });
    if (!r) return res.status(404).json({ error: 'Not found' });
    res.json(r);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteRefund = async (req, res) => {
  try {
    const r = await Refund.findByIdAndDelete(req.params.id);
    if (!r) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};
