const Rating = require('../models/Rating');
const Store = require('../models/Store');
exports.createRating = async (req, res) => {
  try {
    const { storeId, stars, feedback, imageUrl } = req.body;
    const existing = await Rating.findOne({ fromUserId: req.user ? req.user._id : '000000000000000000000000', storeId });
    if (existing) return res.status(400).json({ message: 'لقد قمت بتقييم هذا المتجر مسبقاً' });
    const rating = await Rating.create({ fromUserId: req.user ? req.user._id : '000000000000000000000000', storeId, stars, feedback, imageUrl });
    const all = await Rating.find({ storeId });
    const avg = all.reduce((s, r) => s + r.stars, 0) / all.length;
    await Store.findByIdAndUpdate(storeId, { rating: Math.round(avg * 10) / 10 });
    res.status(201).json(rating);
  } catch (e) { res.status(500).json({ message: e.message }); }
};
