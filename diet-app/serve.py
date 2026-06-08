import http.server, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
handler = http.server.SimpleHTTPRequestHandler
with http.server.HTTPServer(("", 8790), handler) as httpd:
    httpd.serve_forever()
