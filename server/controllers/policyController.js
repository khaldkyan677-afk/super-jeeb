const Policy = require('../models/Policy');

exports.getPolicy = async (req, res) => {
  try {
    const { appType, type } = req.params;
    const policy = await Policy.findOne({ appType, type });
    if (!policy) return res.status(404).json({ message: 'Policy not found' });
    res.json(policy);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.updatePolicy = async (req, res) => {
  try {
    const { appType, type } = req.params;
    const policy = await Policy.findOneAndUpdate(
      { appType, type },
      { content: req.body.content },
      { new: true, upsert: true }
    );
    res.json(policy);
  } catch (err) { res.status(500).json({ message: err.message }); }
};
