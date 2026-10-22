const Report = require('../models/Report');

exports.createReport = async (req, res) => {
  try {
    const { reasonType, reason, againstUserId, storeId, orderId, imageUrl } = req.body;
    if (!reasonType) {
      return res.status(400).json({ message: 'نوع البلاغ مطلوب' });
    }

    const report = await Report.create({
      fromUserId: req.user._id,
      againstUserId,
      storeId,
      orderId,
      reasonType,
      reason: reason || '',
      imageUrl: imageUrl || '',
      status: 'pending'
    });

    res.status(201).json({ message: 'تم استلام البلاغ بنجاح وجاري المراجعة', report });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

exports.getMyReports = async (req, res) => {
  try {
    const reports = await Report.find({ fromUserId: req.user._id }).sort({ createdAt: -1 });
    res.json(reports);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};
