const ExchangeRate = require('../models/ExchangeRate');

exports.getAllRates = async (req, res) => {
  try { res.json(await ExchangeRate.find({})); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getRateById = async (req, res) => {
  try {
    const r = await ExchangeRate.findById(req.params.id);
    if (!r) return res.status(404).json({ error: 'Not found' });
    res.json(r);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createRate = async (req, res) => {
  try { res.status(201).json(await ExchangeRate.create(req.body)); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.updateRate = async (req, res) => {
  try {
    const r = await ExchangeRate.findByIdAndUpdate(req.params.id, req.body, { returnDocument: 'after' });
    if (!r) return res.status(404).json({ error: 'Not found' });
    res.json(r);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteRate = async (req, res) => {
  try {
    const r = await ExchangeRate.findByIdAndDelete(req.params.id);
    if (!r) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};
