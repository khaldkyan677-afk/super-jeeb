const Address = require('../models/Address');

exports.getMyAddresses = async (req, res) => {
  try { res.json(await Address.find({ userId: req.user._id })); }
  catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getAddressById = async (req, res) => {
  try {
    const a = await Address.findOne({ _id: req.params.id, userId: req.user._id });
    if (!a) return res.status(404).json({ error: 'Not found' });
    res.json(a);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createAddress = async (req, res) => {
  try {
    const a = await Address.create({ ...req.body, userId: req.user._id });
    if (a.isDefault) {
      await Address.updateMany({ userId: req.user._id, _id: { $ne: a._id } }, { isDefault: false });
    }
    res.status(201).json(a);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.updateAddress = async (req, res) => {
  try {
    const a = await Address.findOneAndUpdate(
      { _id: req.params.id, userId: req.user._id },
      req.body, { new: true }
    );
    if (!a) return res.status(404).json({ error: 'Not found' });
    if (a.isDefault) {
      await Address.updateMany({ userId: req.user._id, _id: { $ne: a._id } }, { isDefault: false });
    }
    res.json(a);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteAddress = async (req, res) => {
  try {
    const a = await Address.findOneAndDelete({ _id: req.params.id, userId: req.user._id });
    if (!a) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};
