const Report = require('../models/Report');
exports.createReport = async (req, res) => {
  try {
    const report = await Report.create({ ...req.body, fromUserId: req.user ? req.user._id : '000000000000000000000000' });
    res.status(201).json(report);
  } catch (e) { res.status(500).json({ message: e.message }); }
};
exports.getMyReports = async (req, res) => {
  try {
    const reports = await Report.find({ fromUserId: req.user ? req.user._id : '000000000000000000000000' });
    res.json(reports);
  } catch (e) { res.status(500).json({ message: e.message }); }
};
