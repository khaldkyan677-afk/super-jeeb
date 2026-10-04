const Admin = require('../models/Admin');

exports.getAllAdmins = async (req, res) => {
  try { res.json(await Admin.find({}).populate('userId', 'name phone email')); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getAdminById = async (req, res) => {
  try {
    const a = await Admin.findById(req.params.id).populate('userId', 'name phone email');
    if (!a) return res.status(404).json({ error: 'Not found' });
    res.json(a);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createAdmin = async (req, res) => {
  try {
    const a = await Admin.create({ ...req.body, createdBy: req.user._id });
    res.status(201).json(a);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.updateAdmin = async (req, res) => {
  try {
    const a = await Admin.findByIdAndUpdate(req.params.id, req.body, { returnDocument: 'after' });
    if (!a) return res.status(404).json({ error: 'Not found' });
    res.json(a);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteAdmin = async (req, res) => {
  try {
    const a = await Admin.findByIdAndDelete(req.params.id);
    if (!a) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.unlockAdmin = async (req, res) => {
  try {
    const a = await Admin.findByIdAndUpdate(req.params.id, { loginAttempts: 0, lockedUntil: null }, { returnDocument: 'after' });
    if (!a) return res.status(404).json({ error: 'Not found' });
    res.json(a);
  } catch (e) { res.status(500).json({ error: e.message }); }
};
