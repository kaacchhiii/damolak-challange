import pytest
from app import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_index(client):
    rv = client.get('/')
    assert rv.status_code == 200
    assert b"DevOps Challenge" in rv.data

def test_health(client):
    rv = client.get('/health')
    assert rv.status_code == 200
    assert rv.get_json() == {"status": "healthy"}
