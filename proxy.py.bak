import http.server, urllib.request, socketserver, os
os.chdir(os.path.expanduser('~/super-jeeb/build/web'))
PORT, API_PORT = 8080, 5000
class H(http.server.SimpleHTTPRequestHandler):
    def _fwd(self):
        try:
            url = f'http://localhost:{API_PORT}{self.path}'
            length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(length) if length else None
            req = urllib.request.Request(url, data=body, method=self.command)
            for k in ['Content-Type','Authorization']:
                if k in self.headers: req.add_header(k, self.headers[k])
            with urllib.request.urlopen(req) as r:
                self.send_response(r.status)
                for k, v in r.headers.items():
                    if k.lower() not in ['transfer-encoding','connection']:
                        self.send_header(k, v)
                self.end_headers()
                self.wfile.write(r.read())
        except Exception as e:
            self.send_response(502); self.end_headers()
            self.wfile.write(str(e).encode())
    def do_GET(self):
        if self.path.startswith('/api/'): self._fwd()
        else: super().do_GET()
    def do_POST(self): self._fwd()
    def do_PUT(self): self._fwd()
    def do_PATCH(self): self._fwd()
    def do_DELETE(self): self._fwd()
socketserver.TCPServer.allow_reuse_address = True
with socketserver.TCPServer(('', PORT), H) as httpd:
    print(f'Proxy on {PORT} -> API {API_PORT}')
    httpd.serve_forever()
