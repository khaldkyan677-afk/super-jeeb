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
