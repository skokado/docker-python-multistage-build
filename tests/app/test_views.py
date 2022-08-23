from django.test.client import Client

client = Client()


def test_hello():
    response = client.get("/hello/")
    assert response.json() == {"msg": "hello"}
    assert response.status_code == 200
