const Ad = require('../models/Ad');
exports.getAds = async (req, res) => { try { const ads = await Ad.find({ isActive: true }).sort({ order: 1 }); res.json(ads); } catch (e) { res.status(500).json({ message: e.message }); } };
exports.createAd = async (req, res) => { try { const ad = await Ad.create(req.body); res.status(201).json(ad); } catch (e) { res.status(500).json({ message: e.message }); } };
exports.updateAd = async (req, res) => { try { const ad = await Ad.findByIdAndUpdate(req.params.id, req.body, { new: true }); res.json(ad); } catch (e) { res.status(500).json({ message: e.message }); } };
exports.deleteAd = async (req, res) => { try { await Ad.findByIdAndDelete(req.params.id); res.json({ message: 'Deleted' }); } catch (e) { res.status(500).json({ message: e.message }); } };
