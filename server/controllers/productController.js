const Product = require('../models/Product');

exports.getProductsByStore = async (req, res) => {
  try {
    const { storeId } = req.params;
    const products = await Product.find({ storeId, isAvailable: true });
    res.json(products);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

exports.getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ message: 'Product not found' });
    res.json(product);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

exports.createProduct = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const store = await Store.findOne({ merchantId: req.user._id });
    if (!store) return res.status(403).json({ message: 'No store for merchant' });
    const p = await Product.create({ ...req.body, storeId: store._id });
    res.status(201).json(p);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.updateProduct = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const store = await Store.findOne({ merchantId: req.user._id });
    if (!store) return res.status(403).json({ message: 'No store' });
    const p = await Product.findOne({ _id: req.params.id, storeId: store._id });
    if (!p) return res.status(404).json({ message: 'Not found' });
    Object.assign(p, req.body);
    await p.save();
    res.json(p);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.deleteProduct = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const store = await Store.findOne({ merchantId: req.user._id });
    if (!store) return res.status(403).json({ message: 'No store' });
    const p = await Product.findOneAndDelete({ _id: req.params.id, storeId: store._id });
    if (!p) return res.status(404).json({ message: 'Not found' });
    res.json({ message: 'Deleted' });
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.getMyProducts = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const store = await Store.findOne({ merchantId: req.user._id });
    if (!store) return res.json([]);
    const products = await Product.find({ storeId: store._id }).sort({ createdAt: -1 });
    res.json(products);
  } catch (e) { res.status(500).json({ message: e.message }); }
};
