const Section = require('../models/Section');

exports.getSections = async (req, res) => {
  try {
    const sections = await Section.find({ isActive: true }).sort({ order: 1 });
    res.json(sections);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.getAllSections = async (req, res) => {
  try {
    const sections = await Section.find().sort({ order: 1 });
    res.json(sections);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.createSection = async (req, res) => {
  try {
    const section = await Section.create(req.body);
    res.status(201).json(section);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.updateSection = async (req, res) => {
  try {
    const section = await Section.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!section) return res.status(404).json({ message: 'Not found' });
    res.json(section);
  } catch (e) { res.status(500).json({ message: e.message }); }
};

exports.deleteSection = async (req, res) => {
  try {
    const section = await Section.findByIdAndDelete(req.params.id);
    if (!section) return res.status(404).json({ message: 'Not found' });
    res.json({ message: 'Deleted' });
  } catch (e) { res.status(500).json({ message: e.message }); }
};
