

from http.server import HTTPServer, BaseHTTPRequestHandler
import json


class MoMoAPIHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        from api.router import route_request
        status, response = route_request('GET', self.path, self.headers, None)
        self.send_json_response(status, response)

    def do_POST(self):
        from api.router import route_request

        content_length = int(self.headers.get('Content-Length', 0))
        body_text = self.rfile.read(content_length).decode('utf-8')

        try:
            body_data = json.loads(body_text) if body_text else {}
        except:
            self.send_json_response(400, {"error": "Invalid JSON"})
            return

        status, response = route_request('POST', self.path, self.headers, body_data)
        self.send_json_response(status, response)

    def do_PUT(self):
        from api.router import route_request

        content_length = int(self.headers.get('Content-Length', 0))
        body_text = self.rfile.read(content_length).decode('utf-8')

        try:
            body_data = json.loads(body_text) if body_text else {}
        except:
            self.send_json_response(400, {"error": "Invalid JSON"})
            return

        status, response = route_request('PUT', self.path, self.headers, body_data)
        self.send_json_response(status, response)

    def do_DELETE(self):
        from api.router import route_request
        status, response = route_request('DELETE', self.path, self.headers, None)
        self.send_json_response(status, response)

    def send_json_response(self, status_code, response_data):
        self.send_response(status_code)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()

        json_text = json.dumps(response_data)
        self.wfile.write(json_text.encode('utf-8'))

    def log_message(self, format, *args):
        # Suppress default server logs to keep terminal clean
        pass


def run_server(port=8000):
    server = HTTPServer(('localhost', port), MoMoAPIHandler)
    print(f"MoMo API Server running on http://localhost:{port}")
    print("Press Ctrl+C to stop")
    server.serve_forever()


if __name__ == '__main__':
    run_server()