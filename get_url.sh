#!/bin/bash
grep -o "https://[a-z0-9-]*\.trycloudflare\.com" /tmp/tunnel_web.log | head -1 || echo "النفق غير متصل حالياً"
