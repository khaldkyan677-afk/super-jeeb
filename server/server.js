const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const connectDB = require('./config/db');

dotenv.config();
connectDB();

const app = express();
app.use(express.json());
app.use(cors());
app.use(helmet());

const limiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 100 });
app.use('/api', limiter);

app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/favorites', require('./routes/favoriteRoutes'));
app.use('/api/ratings', require('./routes/ratingRoutes'));
app.use('/api/reports', require('./routes/reportRoutes'));
app.use('/api/admin-auth', require('./routes/adminAuthRoutes'));
app.use('/api/orders', require('./routes/orderRoutes'));
app.use('/api/sections', require('./routes/sectionRoutes'));
app.use('/api/stores', require('./routes/storeRoutes'));
app.use('/api/ads', require('./routes/adRoutes'));
app.use('/api/wallet', require('./routes/walletRoutes'));
app.use('/api/notifications', require('./routes/notificationRoutes'));
app.use('/api/chat', require('./routes/chatRoutes'));
app.use('/api/taxi', require('./routes/taxiRoutes'));

app.get('/api/health', (req, res) => { res.status(200).json({ status: 'OK', message: 'Super-Jeeb Server is running' }); });

app.use((err, req, res, next) => { console.error(err.stack); res.status(500).json({ message: 'Something went wrong!' }); });

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => { console.log(`Server running on port ${PORT}`); });
