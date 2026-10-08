# Super Jeeb — دليل الاسترداد

## 1) استنساخ المشروع
git clone https://github.com/khaldkyan677-afk/super-jeeb.git ~/super-jeeb

## 2) إنشاء .env (انسخ القيم من مكان آمن)
cd ~/super-jeeb/server
cat > .env << 'ENVEOF'
MONGO_URI=<ضع رابط MongoDB هنا>
PORT=5000
JWT_SECRET=super_jeeb_jwt_secret_2026
ENVEOF

## 3) مكتبات Flutter
cd ~/super-jeeb && flutter pub get

## 4) مكتبات السيرفر
cd ~/super-jeeb/server && npm install

## 5) تنزيل cloudflared
mkdir -p ~/bin
curl -sL -o ~/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x ~/bin/cloudflared

## 6) بناء التطبيق
cd ~/super-jeeb && flutter build web --release --no-web-resources-cdn --pwa-strategy=none

## 7) تنزيل eruda
cd ~/super-jeeb/build/web
curl -sL -o eruda.min.js https://cdn.jsdelivr.net/npm/eruda
python3 -c "
with open('index.html','r') as f: h=f.read()
if 'eruda' not in h:
    h=h.replace('</body>','<script src=\"/eruda.min.js\"></script><script>eruda.init();</script></body>')
    with open('index.html','w') as f: f.write(h)
"

## 8) تشغيل السيرفر
cd ~/super-jeeb/server && node server.js

## 9) تشغيل Tunnel
~/bin/cloudflared tunnel --url http://localhost:5000
