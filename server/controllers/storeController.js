const Store = require('../models/Store');
exports.getStores = async (req, res) => {
  try { const stores = await Store.find({ isActive: true }); res.json(stores); } catch (e) { res.status(500).json({ message: e.message }); }
};
exports.getStoresBySection = async (req, res) => {
  try { const stores = await Store.find({ sectionId: req.params.sectionId, isActive: true }); res.json(stores); } catch (e) { res.status(500).json({ message: e.message }); }
};
exports.createStore = async (req, res) => {
  try { const store = await Store.create(req.body); res.status(201).json(store); } catch (e) { res.status(500).json({ message: e.message }); }
};
