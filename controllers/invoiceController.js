const Invoice = require('../models/Invoice');

exports.getMyInvoices = async (req, res) => {
  try { res.json(await Invoice.find({ userId: req.user._id })); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getInvoiceById = async (req, res) => {
  try {
    const i = await Invoice.findById(req.params.id);
    if (!i) return res.status(404).json({ error: 'Not found' });
    res.json(i);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getAllInvoices = async (req, res) => {
  try { res.json(await Invoice.find({})); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createInvoice = async (req, res) => {
  try { res.status(201).json(await Invoice.create(req.body)); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteInvoice = async (req, res) => {
  try {
    const i = await Invoice.findByIdAndDelete(req.params.id);
    if (!i) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};
