const Receipt = require('../models/Receipt');

exports.getMyReceipts = async (req, res) => {
  try { res.json(await Receipt.find({ userId: req.user._id })); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getReceiptById = async (req, res) => {
  try {
    const r = await Receipt.findById(req.params.id);
    if (!r) return res.status(404).json({ error: 'Not found' });
    res.json(r);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getAllReceipts = async (req, res) => {
  try { res.json(await Receipt.find({})); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createReceipt = async (req, res) => {
  try { res.status(201).json(await Receipt.create(req.body)); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteReceipt = async (req, res) => {
  try {
    const r = await Receipt.findByIdAndDelete(req.params.id);
    if (!r) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};
