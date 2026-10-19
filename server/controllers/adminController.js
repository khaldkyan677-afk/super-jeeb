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


exports.getAdminMerchants = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const stores = await Store.find({ merchantId: { $exists: true, $ne: null } }).sort({ createdAt: -1 });
    res.json({ merchants: stores, applications: [] });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.toggleMerchantStatus = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const store = await Store.findById(req.params.id);
    if (!store) return res.status(404).json({ message: 'Store not found' });
    store.isActive = !store.isActive;
    await store.save();
    res.json({ message: 'Status toggled', store });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.deleteMerchant = async (req, res) => {
  try {
    const Store = require('../models/Store');
    await Store.findByIdAndDelete(req.params.id);
    res.json({ message: 'Store deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};


exports.verifyMerchant = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const { action } = req.body;
    const store = await Store.findById(req.params.id);
    if (!store) return res.status(404).json({ message: 'Store not found' });

    if (action === 'accept') {
      store.isVerified = true;
      store.isActive = true;
      store.documentsVerified = true;
    } else if (action === 'reject') {
      store.isVerified = false;
      store.isActive = false;
      store.documentsVerified = false; // تمييز المرفوض عن المعلق
      store.rejectionReason = req.body.reason || 'بدون سبب محدد';
    }
    await store.save();
    res.json({ message: 'Status updated', store });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.sendAlert = async (req, res) => {
  try {
    const { message } = req.body;
    console.log(`[ALERT] To Merchant ${req.params.id}: ${message}`);
    res.json({ success: true, message: 'Alert sent' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.updateCommission = async (req, res) => {
  try {
    const Store = require('../models/Store');
    const { commission } = req.body;
    const store = await Store.findByIdAndUpdate(req.params.id, { commission }, { new: true });
    res.json({ success: true, store });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.getDriverApplications = async (req, res) => {
  try {
    const User = require('../models/User');
    const drivers = await User.find({ driverStatus: 'pending' });
    res.json({ drivers });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.verifyDriverApplication = async (req, res) => {
  try {
    const User = require('../models/User');
    const { action, reason } = req.body;
    const updateData = action === 'accept' 
      ? { driverStatus: 'approved', role: 'driver' }
      : { driverStatus: 'rejected', driverRejectionReason: reason || 'بدون سبب' };
      
    const user = await User.findByIdAndUpdate(req.params.id, updateData, { new: true });
    res.json({ success: true, user });
  } catch (err) { res.status(500).json({ message: err.message }); }
};
