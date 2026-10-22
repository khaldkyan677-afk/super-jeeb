const multer = require('multer');
const path = require('path');
const fs = require('fs');

const uploadDir = path.join(__dirname, '..', 'uploads');
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadDir),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname) || '.png';
    const unique = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, unique + ext);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 },
});

// قبول أي حقل صورة يرسله فلاتر (file أو image أو avatar أو غيرها)
exports.uploadSingle = upload.any();

exports.handleUpload = (req, res) => {
  const file = req.file || (req.files && req.files[0]);
  if (!file) return res.status(400).json({ error: 'لم يتم رفع ملف' });
  const url = '/uploads/' + file.filename;
  res.json({ url, imageUrl: url, filename: file.filename, success: true });
};
