require('../models/User');
const Merchant = require('../models/Merchant');

exports.getAllMerchants = async (req, res) => {
  try {
    const list = await Merchant.find({ isActive: true });
    res.json(list);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getMerchantById = async (req, res) => {
  try {
    const m = await Merchant.findById(req.params.id);
    if (!m) return res.status(404).json({ error: 'Not found' });
    res.json(m);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getMyMerchant = async (req, res) => {
  try {
    const m = await Merchant.findOne({ userId: req.user._id });
    res.json(m);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.createMerchant = async (req, res) => {
  try {
    const Store = require('../models/Store');
  const Section = require('../models/Section');
    const body = req.body || {};
    const existing = await Store.findOne({ merchantId: req.user._id });
    if (existing) return res.status(400).json({ error: 'لديك متجر بالفعل' });
  let category = body.category || '';
  let sectionId = body.sectionId || null;
  const catMap = {
    '\u0633\u0648\u0628\u0631\u0645\u0627\u0631\u0643\u062a': 'supermarket',
    '\u0645\u0637\u0627\u0639\u0645': 'restaurant',
    '\u0645\u0637\u0639\u0645': 'restaurant',
    '\u0635\u064a\u062f\u0644\u064a\u0627\u062a': 'pharmacy',
    '\u0635\u064a\u062f\u0644\u064a\u0629': 'pharmacy',
    '\u0628\u0642\u0627\u0644\u0627\u062a': 'grocery',
    '\u0628\u0642\u0627\u0644\u0629': 'grocery',
    '\u0645\u062a\u0627\u062c\u0631': 'mall',
    '\u0645\u062a\u062c\u0631': 'mall',
  };
  const catName = catMap[body.category] ? body.category : null;
  if (catMap[body.category]) category = catMap[body.category];
  if (!sectionId && catName) {
    const sec = await Section.findOne({ name: catName });
    if (sec) sectionId = sec._id;
  }
  if (!sectionId && category) {
    const nameMap = { supermarket: '\u0633\u0648\u0628\u0631\u0645\u0627\u0631\u0643\u062a', restaurant: '\u0645\u0637\u0627\u0639\u0645', pharmacy: '\u0635\u064a\u062f\u0644\u064a\u0627\u062a', grocery: '\u0628\u0642\u0627\u0644\u0627\u062a', mall: '\u0645\u062a\u0627\u062c\u0631' };
    const sec = await Section.findOne({ name: nameMap[category] });
    if (sec) sectionId = sec._id;
  }
  const store = await Store.create({
    merchantId: req.user._id,
    name: body.storeName || body.name || '',
    description: body.description || '',
    category: category,
    subCategory: body.subCategory || '',
    sectionId: sectionId,
    phone: body.phone || '',
    logoUrl: body.logoUrl || '',
    coverUrl: body.coverUrl || '',
    governorate: body.governorate || '',
    city: body.city || '',
    location: body.location || {},
    mapUrl: body.mapUrl || '',
    workingHours: body.workingHours || '',
    isActive: false,
  });
    res.status(201).json({ _id: store._id, store });
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.updateMerchant = async (req, res) => {
  try {
    const m = await Merchant.findByIdAndUpdate(req.params.id, req.body, { returnDocument: 'after' });
    if (!m) return res.status(404).json({ error: 'Not found' });
    res.json(m);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.deleteMerchant = async (req, res) => {
  try {
    const m = await Merchant.findByIdAndDelete(req.params.id);
    if (!m) return res.status(404).json({ error: 'Not found' });
    res.json({ ok: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.verifyMerchant = async (req, res) => {
  try {
    const { action, reason } = req.body;
    const Store = require('../models/Store');
    const User = require('../models/User');
    const store = await Store.findById(req.params.id);
    if (!store) return res.status(404).json({ error: 'Not found' });
    if (action === 'accept') {
      store.isActive = true;
      await store.save();
      await User.findByIdAndUpdate(store.merchantId, { role: 'merchant', status: 'approved' });
    } else if (action === 'reject') {
      store.isActive = false;
      await store.save();
    } else {
      return res.status(400).json({ error: 'Invalid action' });
    }
    res.json(store);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getAllMerchantsAdmin = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const User = require('../models/User');
    const filter = {};
    if (req.query.verificationStatus === 'pending') filter.isActive = false;
    if (req.query.verificationStatus === 'verified') filter.isActive = true;
    const list = await Store.find(filter)
      .populate('merchantId', 'name phone email')
      .sort({ createdAt: -1 });
    res.json(list);
  } catch (e) { res.status(500).json({ error: e.message }); }
};

exports.getMyStore = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const Order = require('../models/Order');
    const store = await Store.findOne({ merchantId: req.user._id });
    if (!store) return res.status(404).json({ message: 'Store not found' });

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const [newCount, preparing, delivered, totalRevenue, todayOrders] = await Promise.all([
      Order.countDocuments({ storeId: store._id, status: 'pending' }),
      Order.countDocuments({ storeId: store._id, status: { $in: ['accepted', 'preparing', 'ready'] } }),
      Order.countDocuments({ storeId: store._id, status: 'delivered' }),
      Order.aggregate([
        { $match: { storeId: store._id, status: 'delivered' } },
        { $group: { _id: null, sum: { $sum: '$total' } } }
      ]),
      Order.countDocuments({ storeId: store._id, createdAt: { $gte: today } }),
    ]);

    res.json({
      store: {
        _id: store._id,
        name: store.name,
        category: store.category,
        logoUrl: store.logoUrl,
        coverUrl: store.coverUrl,
        rating: store.rating,
        isActive: store.isActive,
      },
      stats: {
        newOrders: newCount,
        preparing: preparing,
        delivered: delivered,
        totalRevenue: totalRevenue[0]?.sum || 0,
        todayOrders: todayOrders,
      },
    });
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.updateMyStore = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const Section = require('../models/Section');
    const store = await Store.findOne({ merchantId: req.user._id });
    if (!store) return res.status(404).json({ message: 'Store not found' });

    const { name, description, phone, category, location, isActive } = req.body;
    if (name) store.name = name;
    if (description != null) store.description = description;
    if (phone != null) store.phone = phone;
    if (location != null) store.location = location;
    if (isActive != null) store.isActive = isActive;
    if (category) {
      store.category = category;
      const map = {
        supermarket: 'سوبرماركت',
        restaurant: 'مطاعم',
        pharmacy: 'صيدليات',
        grocery: 'بقالات',
        mall: 'متاجر',
      };
      const secName = map[category];
      if (secName) {
        const sec = await Section.findOne({ name: secName });
        if (sec) store.sectionId = sec._id;
      }
    }
    await store.save();
    res.json({ store });
  } catch (e) { res.status(500).json({ message: e.message }); }
};
