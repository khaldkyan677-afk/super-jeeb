const Store = require('../models/Store');
exports.getStores = async (req, res) => {
  try {
    const filter = { isActive: true };
    if (req.query.category) filter.category = req.query.category;
    if (req.query.merchantId) filter.merchantId = req.query.merchantId;
    const stores = await Store.find(filter);
    res.json(stores);
  } catch (e) { res.status(500).json({ message: e.message }); }
};
exports.getStoresBySection = async (req, res) => {
  try { const stores = await Store.find({ sectionId: req.params.sectionId, isActive: true }); res.json(stores); } catch (e) { res.status(500).json({ message: e.message }); }
};
exports.createStore = async (req, res) => {
  try { const store = await Store.create(req.body); res.status(201).json(store); } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.getAllStoresAdmin = async (req, res) => {
  try {
    const stores = await Store.find().sort({ createdAt: -1 });
    res.json(stores);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.updateStore = async (req, res) => {
  try {
    const store = await Store.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!store) return res.status(404).json({ message: 'Not found' });
    res.json(store);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.deleteStore = async (req, res) => {
  try {
    const store = await Store.findByIdAndDelete(req.params.id);
    if (!store) return res.status(404).json({ message: 'Not found' });
    res.json({ message: 'Deleted' });
  } catch (e) { res.status(500).json({ message: e.message }); }
};
