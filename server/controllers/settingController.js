const Setting = require('../models/Setting');

exports.getAllSettings = async (req, res) => {
  try {
    const list = await Setting.find({ isSecret: false });
    res.json(list);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getSettingByKey = async (req, res) => {
  try {
    const s = await Setting.findOne({ key: req.params.key });
    if (!s) return res.status(404).json({ error: 'Not found' });
    res.json(s);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getSettingsByGroup = async (req, res) => {
  try {
    const list = await Setting.find({ group: req.params.group, isSecret: false });
    res.json(list);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createSetting = async (req, res) => {
  try {
    const s = await Setting.create({ ...req.body, updatedBy: req.user._id });
    res.status(201).json(s);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.updateSetting = async (req, res) => {
  try {
    const s = await Setting.findOneAndUpdate(
      { key: req.params.key },
      { ...req.body, updatedBy: req.user._id, updatedAt: new Date() },
      { returnDocument: 'after' }
    );
    if (!s) return res.status(404).json({ error: 'Not found' });
    res.json(s);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteSetting = async (req, res) => {
  try {
    const s = await Setting.findOneAndDelete({ key: req.params.key });
    if (!s) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};
