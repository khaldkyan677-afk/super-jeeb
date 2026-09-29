import http.server, urllib.request, urllib.error, socketserver, os, sys

os.chdir(os.path.expanduser("~/super-jeeb/build/web/"))
PORT = 8080
API_PORT = 5000
API_BASE = f"http://localhost:{API_PORT}"

FORWARD_HEADERS = ["content-type", "authorization", "x-device-id", "accept", "accept-language", "user-agent"]
SKIP_HEADERS = ["transfer-encoding", "connection", "content-encoding", "content-length",
                "access-control-allow-origin", "access-control-allow-methods",
                "access-control-allow-headers", "access-control-max-age"]


class Handler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, fmt, *args):
        sys.stderr.write("[proxy] " + (fmt % args) + "\n")

    def _cors(self):
        origin = self.headers.get("Origin", "*")
        self.send_header("Access-Control-Allow-Origin", origin)
        self.send_header("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS")
        req_h = self.headers.get("Access-Control-Request-Headers", "")
        self.send_header("Access-Control-Allow-Headers",
                         req_h if req_h else "Content-Type, Authorization, X-Device-Id, Accept, Accept-Language")
        self.send_header("Access-Control-Max-Age", "86400")
        self.send_header("Vary", "Origin")

    def do_OPTIONS(self):
        self.send_response(204)
        self._cors()
        self.end_headers()

    def _fwd(self):
        try:
            url = API_BASE + self.path
            length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(length) if length else None
            req = urllib.request.Request(url, data=body, method=self.command)
            for k in FORWARD_HEADERS:
                v = self.headers.get(k)
                if v:
                    req.add_header(k, v)
            try:
                with urllib.request.urlopen(req, timeout=30) as r:
                    self.send_response(r.status)
                    for k, v in r.headers.items():
                        if k.lower() not in SKIP_HEADERS:
                            self.send_header(k, v)
                    self._cors()
                    self.end_headers()
                    self.wfile.write(r.read())
            except urllib.error.HTTPError as e:
                self.send_response(e.code)
                for k, v in e.headers.items():
                    if k.lower() not in SKIP_HEADERS:
                        self.send_header(k, v)
                self._cors()
                self.end_headers()
                self.wfile.write(e.read())
        except Exception as e:
            self.send_response(502)
            self._cors()
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(('{"error":"' + str(e).replace('"', "'") + '"}').encode())

    def do_GET(self):
        if self.path.startswith("/api/"):
            self._fwd()
        else:
            for h in ["If-Modified-Since", "If-None-Match", "If-Match", "If-Unmodified-Since"]:
                if h in self.headers:
                    del self.headers[h]
            if not os.path.exists(self.translate_path(self.path)) or os.path.isdir(self.translate_path(self.path)):
                self.path = "/index.html"
            super().do_GET()

    def end_headers(self):
        if not self.path.startswith("/api/"):
            self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
            self.send_header("Pragma", "no-cache")
            self.send_header("Expires", "0")
        super().end_headers()

    def do_POST(self): self._fwd()
    def do_PUT(self): self._fwd()
    def do_PATCH(self): self._fwd()
    def do_DELETE(self): self._fwd()


class ThreadingServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    allow_reuse_address = True
    daemon_threads = True


if __name__ == "__main__":
    with ThreadingServer(("", PORT), Handler) as httpd:
        print(f"Proxy on {PORT} -> API {API_PORT}")
        httpd.serve_forever()
