import base64

import requests

from tests.test_data.test_users import FAKE_USER_1

ROOT_URL = 'http://127.0.0.1:5000'


def test_static_file():
    response = requests.get(ROOT_URL + '/static/foo.html')
    assert response.status_code == 200


def test_create_user_and_read_back():
    created_user = requests.post(ROOT_URL + '/v1/register', json=FAKE_USER_1).json()
    get_response = requests.get(ROOT_URL + f'/v1/user/{created_user["_id"]["$oid"]}')
    # Check to see if FAKE_USER_JSON is a subset of the response. (i.e every key: value in
    # FAKE_USER_JSON is also in the response).
    assert FAKE_USER_1.items() <= get_response.json().items()


def test_create_image():
    created_user = requests.post(ROOT_URL + '/v1/register', json=FAKE_USER_1).json()
    created_user_id = created_user["_id"]["$oid"]
    with open('./test_data/test_image.jpg', 'rb') as test_image:
        image_bytes = test_image.read()
        encoded_image = base64.encodebytes(image_bytes).decode('utf-8')
    requests.post(ROOT_URL + f'/v1/user/{created_user_id}/image', json={
        'title': 'Test Image',
        'caption': 'This is a test image',
        'latitude': 2133.123,
        'longitude': 1232.213,
        'image': encoded_image
    })
    fetched_user = requests.get(ROOT_URL + f'/v1/user/{created_user_id}')
    assert len(fetched_user.json()['images']) == 1
