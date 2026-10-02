const AuditLog = require('../models/AuditLog');
const ErrorLog = require('../models/ErrorLog');

// تسجيل تلقائي للأخطاء
exports.errorLogger = (err, req, res, next) => {
  ErrorLog.create({
    level: 'error',
    message: err.message || 'Unknown error',
    stack: err.stack,
    endpoint: req.originalUrl,
    method: req.method,
    userId: req.user?._id,
    ip: req.ip,
    meta: { body: req.body, query: req.query }
  }).catch(() => {});
  next(err);
};

// تسجيل يدوي لعمليات حساسة
exports.auditAction = (action, entity) => async (req, res, next) => {
  const originalJson = res.json.bind(res);
  res.json = (body) => {
    if (res.statusCode < 400) {
      AuditLog.create({
        userId: req.user?._id,
        userRole: req.user?.role,
        action,
        entity,
        entityId: body?._id,
        ip: req.ip,
        userAgent: req.headers['user-agent'],
        description: `${action} on ${entity}`
      }).catch(() => {});
    }
    return originalJson(body);
  };
  next();
};
