const express = require('express');
const compression = require('compression');
const { errorLogger } = require('./middleware/logging');
const dotenv = require('dotenv');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const connectDB = require('./config/db');
const path = require('path');

dotenv.config();
connectDB();

const app = express();
app.set('trust proxy', 1);

// 1. تفعيل ضغط البيانات Gzip لتسريع استجابة السيرفر وتحميل الويب
app.use(compression());

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// إيقاف التخزين المؤقت للبيانات الحية
app.use((req, res, next) => {
  res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0');
  res.setHeader('Pragma', 'no-cache');
  res.setHeader('Expires', '0');
  next();
});

app.use(express.json({ limit: '10mb', type: ["application/json", "text/plain"] }));
app.use(cors());
app.use(helmet({ contentSecurityPolicy: false, crossOriginEmbedderPolicy: false }));

// 2. سقف تقني قياسي (1500 طلب لكل جهاز / 15 دقيقة) يمنع الاختناق ويحمي من الهجمات
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 1500,
  message: { message: 'تم تجاوز الحد المسموح من الطلبات، يرجى المحاولة بعد قليل' }
});
app.use('/api', limiter);

// مسارات النظام
app.use('/api/users', require('./routes/userRoutes'));
app.use('/api/upload', require('./routes/uploadRoutes'));
app.use('/api/driver', require('./routes/driverRoutes'));
app.use('/api/logs', require('./routes/logRoutes'));
app.use('/api/withdrawals', require('./routes/withdrawalRoutes'));
app.use('/api/otp', require('./routes/otpRoutes'));
app.use('/api/payments', require('./routes/paymentRoutes'));
app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/favorites', require('./routes/favoriteRoutes'));
app.use('/api/ratings', require('./routes/ratingRoutes'));
app.use('/api/reports', require('./routes/reportRoutes'));
app.use('/api/admin-auth', require('./routes/adminAuthRoutes'));
app.use('/api/orders', require('./routes/orderRoutes'));
app.use('/api/sections', require('./routes/sectionRoutes'));
app.use('/api/stores', require('./routes/storeRoutes'));
app.use('/api/products', require('./routes/productRoutes'));
app.use('/api/ads', require('./routes/adsRoutes'));
app.use('/api/wallet', require('./routes/walletRoutes'));
app.use('/api/notifications', require('./routes/notificationRoutes'));
app.use('/api/merchants', require('./routes/merchantRoutes'));
app.use('/api/settings', require('./routes/settingRoutes'));
app.use('/api/cities', require('./routes/cityRoutes'));
app.use('/api/districts', require('./routes/districtRoutes'));
app.use('/api/addresses', require('./routes/addressRoutes'));
app.use('/api/coupons', require('./routes/couponRoutes'));
app.use('/api/exchange-rates', require('./routes/exchangeRateRoutes'));
app.use('/api/official-accounts', require('./routes/officialAccountRoutes'));
app.use('/api/invoices', require('./routes/invoiceRoutes'));
app.use('/api/receipts', require('./routes/receiptRoutes'));
app.use('/api/refunds', require('./routes/refundRoutes'));
app.use('/api/admins', require('./routes/adminRoutes'));
app.use('/api/chat', require('./routes/chatRoutes'));
app.use('/api/taxi', require('./routes/taxiRoutes'));

app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'OK', message: 'Super-Jeeb Server is running' });
});

app.use(errorLogger);
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Something went wrong!' });
});

// خدمة ملفات الويب
const buildPath = path.join(require('os').homedir(), 'super-jeeb/build/web');
app.use((req, res, next) => {
  if (req.url.endsWith('.wasm')) res.setHeader('Content-Type', 'application/wasm');
  if (req.url.endsWith('.mjs')) res.setHeader('Content-Type', 'text/javascript');
  next();
});

app.use(express.static(buildPath));
app.use('/v2', express.static(buildPath));
app.use('/v2', (req, res, next) => {
  if (req.path.startsWith('/api/')) return next();
  if (req.method !== 'GET') return next();
  res.sendFile(path.join(buildPath, 'index.html'));
});
app.use((req, res, next) => {
  if (req.path.startsWith('/api/')) return next();
  if (req.method !== 'GET') return next();
  res.sendFile(path.join(buildPath, 'index.html'));
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
