#!/usr/bin/env python3

from fredcast.app.app_factory import create_app
import sys
# from waitress import serve

app = create_app()

if __name__ == '__main__':
    app.run(host = '0.0.0.0', port = 8080)
