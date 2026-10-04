const District = require('../models/District');

exports.getAllDistricts = async (req, res) => {
  try { res.json(await District.find({})); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getDistrictsByCity = async (req, res) => {
  try { res.json(await District.find({ cityId: req.params.cityId })); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getDistrictById = async (req, res) => {
  try {
    const d = await District.findById(req.params.id);
    if (!d) return res.status(404).json({ error: 'Not found' });
    res.json(d);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createDistrict = async (req, res) => {
  try { res.status(201).json(await District.create(req.body)); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.updateDistrict = async (req, res) => {
  try {
    const d = await District.findByIdAndUpdate(req.params.id, req.body, { returnDocument: 'after' });
    if (!d) return res.status(404).json({ error: 'Not found' });
    res.json(d);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteDistrict = async (req, res) => {
  try {
    const d = await District.findByIdAndDelete(req.params.id);
    if (!d) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};
