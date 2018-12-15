import pytest
from pkgname.modulename.modulename_main import create_app
import os

@pytest.fixture
def app():
    # Not 100% sure why, but both of these appear in the Flask docs. They might
    # be redundant. Prior to the change, I only had the dict arg, not the
    # direct property assignment
    app = create_app({'TESTING': True})
    app.testing = True
    return app

@pytest.fixture
def client(app):
    return app.test_client()

@pytest.fixture
def teardown():
    os.remove('test.db')
