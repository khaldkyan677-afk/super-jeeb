const City = require('../models/City');

exports.getAllCities = async (req, res) => {
  try { res.json(await City.find({})); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getCityById = async (req, res) => {
  try {
    const c = await City.findById(req.params.id);
    if (!c) return res.status(404).json({ error: 'Not found' });
    res.json(c);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createCity = async (req, res) => {
  try { res.status(201).json(await City.create(req.body)); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.updateCity = async (req, res) => {
  try {
    const c = await City.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!c) return res.status(404).json({ error: 'Not found' });
    res.json(c);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteCity = async (req, res) => {
  try {
    const c = await City.findByIdAndDelete(req.params.id);
    if (!c) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};
