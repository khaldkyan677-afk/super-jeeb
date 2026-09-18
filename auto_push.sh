#!/bin/bash
# رفع تلقائي كل 10 دقائق
while true; do
  sleep 600
  cd /home/khaldkyan677/super_jeeb
  if [[ -n $(git status --porcelain) ]]; then
    git add .
    git commit -m "تحديث تلقائي $(date '+%Y-%m-%d %H:%M')"
    git push
    echo "✅ تم الرفع: $(date '+%Y-%m-%d %H:%M')"
  else
    echo "💤 لا توجد تغييرات"
  fi
done
