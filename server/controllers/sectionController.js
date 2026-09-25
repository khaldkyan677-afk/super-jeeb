const Section = require('../models/Section');
exports.getSections = async (req, res) => {
  try { const sections = await Section.find({ isActive: true }).sort({ order: 1 }); res.json(sections); } catch (e) { res.status(500).json({ message: e.message }); }
};
exports.createSection = async (req, res) => {
  try { const section = await Section.create(req.body); res.status(201).json(section); } catch (e) { res.status(500).json({ message: e.message }); }
};
