const OfficialAccount = require('../models/OfficialAccount');

exports.getAllAccounts = async (req, res) => {
  try { res.json(await OfficialAccount.find({})); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getAccountById = async (req, res) => {
  try {
    const a = await OfficialAccount.findById(req.params.id);
    if (!a) return res.status(404).json({ error: 'Not found' });
    res.json(a);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createAccount = async (req, res) => {
  try { res.status(201).json(await OfficialAccount.create(req.body)); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.updateAccount = async (req, res) => {
  try {
    const a = await OfficialAccount.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!a) return res.status(404).json({ error: 'Not found' });
    res.json(a);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteAccount = async (req, res) => {
  try {
    const a = await OfficialAccount.findByIdAndDelete(req.params.id);
    if (!a) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};
