"""
Define pytest fixtures if needed, which you can pass & reference as args to
other test functions. Example skeleton for a Flask app left here, which would
also require installing the `pytest-flask` extension module.
"""
# import pytest
# from pkgname import create_app

# @pytest.fixture
# def app():
#     # Not 100% sure why, but both of these appear in the Flask docs. They might
#     # be redundant.
#     app = create_app({'TESTING': True})
#     app.testing = True
#     return app

# @pytest.fixture
# def client(app):
#     return app.test_client()

# @pytest.fixture
# def teardown():
#     """
#     Dummy 'test' fixture for teardown functionality, like removing SQLite DB,
#     etc.
#     """
#     os.remove('test.db')
