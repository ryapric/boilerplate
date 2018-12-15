#!/usr/bin/env python3

from flask import Flask, request
import pkgname.modulename.modulename as xyz
from waitress import serve

def create_app(test_config = None):
    app = Flask(__name__)

    # Flag for when running tests
    testing = True if (test_config is not None and test_config['TESTING']) else False

    # Health check
    @app.route('/health', methods = ['GET'])
    def app_health():
        return '{"msg": "ok"}', 200

    @app.route('/api/some_endpoint', methods = ['POST'])
    def some_endpoint():
        return 200

    return app
# /create_app()

def main_dev(host = '0.0.0.0', port = 8089):
    app = create_app()
    app.run(host = host, port = port)

def main(host = '0.0.0.0', port = 8089):
    app = create_app()
    serve(app, host = host, port = port)

if __name__ == '__main__':
    main()
