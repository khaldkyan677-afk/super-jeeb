const Rating = require('../models/Rating');
const Store = require('../models/Store');

exports.createRating = async (req, res) => {
  try {
    const { storeId, stars, feedback, imageUrl, orderId } = req.body;
    if (!storeId || !stars) {
      return res.status(400).json({ message: 'معرف المتجر والتقييم بالنجوم مطلوبان' });
    }

    const existing = await Rating.findOne({ fromUserId: req.user._id, storeId });
    if (existing) {
      return res.status(400).json({ message: 'لقد قمت بتقييم هذا المتجر مسبقاً' });
    }

    const rating = await Rating.create({
      fromUserId: req.user._id,
      storeId,
      orderId,
      stars: Math.min(5, Math.max(1, Number(stars))),
      feedback: feedback || '',
      imageUrl: imageUrl || ''
    });

    // إعادة احتساب المتوسط الحسابي لتقييم المتجر بدقة
    const all = await Rating.find({ storeId });
    const avg = all.reduce((s, r) => s + r.stars, 0) / all.length;
    await Store.findByIdAndUpdate(storeId, { rating: Math.round(avg * 10) / 10 });

    res.status(201).json(rating);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};
