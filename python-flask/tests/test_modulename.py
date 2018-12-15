import pytest
import pkgname.modulename.modulename_helpers as xyz
import tests.dummy_data as dd
import json
import numpy as np
import pandas as pd
import requests
from sqlalchemy import create_engine
import sys

# Create test DB, and connect
dd.db_create()
db_con = xyz.db_connect(testing = True)

def test_health(client):
    """Does the app launch, and return health status when asked?"""
    r = client.get('/health')
    assert r.status_code == 200
    assert r.data == b'{"msg": "ok"}'

def test_db_connect():
    """Can you connect to the database, and read existing data from it?"""
    for tblname in xyz.tblnames:
        data = pd.read_sql(f"SELECT * FROM {tblname} LIMIT 5;", db_con)
        assert len(data.index) == 5
        assert len(data.columns) == 10
        assert np.sum(data['colname']) > 0

def test_teardown(teardown):
    """
    Dummy 'test' providing teardown functionality.

    External (i.e. unscoped) teardown occurs in the test fixture found in
    conftest.py.
    """
    db_con.close()
    assert 1 == 1
