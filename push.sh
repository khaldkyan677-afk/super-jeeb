#!/bin/bash
# سكربت الرفع التلقائي إلى GitHub

echo "📦 جاري تجهيز الملفات..."
git add .

echo "📝 جاري إدخال رسالة..."
MSG="${1:-تحديث تلقائي $(date '+%Y-%m-%d %H:%M')}"
git commit -m "$MSG"

echo "🚀 جاري الرفع..."
git push

echo "✅ تم الرفع بنجاح!"
