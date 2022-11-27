import base64
import os.path
import uuid

import flask
from flask import Flask, request, Response
from flask_cors import CORS

from backend.model.image import Image
from backend.model.user import User

from google.protobuf import json_format

STATIC_IMAGE_DIRECTORY = './static/'


app = Flask(__name__)
CORS(app)


@app.route('/v1/register', methods=['POST'])
def register_user():
    request_body = request.get_json()
    existing_user = User.objects(email=request_body['email'])
    if len(existing_user) > 0:
        return Response('User already exists.', 403)
    db_user = User(
        given_name=request_body['given_name'],
        family_name=request_body['family_name'],
        email=request_body['email'],
        password=request_body['password']
    ).save()
    return db_user.to_api()


@app.route('/v1/user/<user_id>/image', methods=['POST'])
def add_image(user_id: str):
    try:
        user = User.objects(id=user_id)[0]
        image_id = uuid.uuid4()
        request_body = request.get_json()
        image_bytes = base64.decodebytes(bytes(request_body['image'], 'utf-8'))
        if not os.path.exists(STATIC_IMAGE_DIRECTORY):
            os.mkdir(STATIC_IMAGE_DIRECTORY)
        with open(os.path.join(STATIC_IMAGE_DIRECTORY, f'{image_id}.jpg'), 'wb') as image_file:
            image_file.write(image_bytes)
        user.images.append(Image(
            title=request_body['title'],
            caption=request_body['caption'],
            uri=f'127.0.0.1:5000/static/{image_id}.jpg',
            latitude=request_body['latitude'],
            longitude=request_body['longitude'])
        )
        user.save()
        return user.to_json()
    except Exception as e:
        print('Something happened: ' + str(e))


@app.route('/v1/login', methods=['POST'])
def login():
    request_body = request.get_json()
    print(request_body)
    user_matches = User.objects(email=request_body['email'])
    if len(user_matches) != 1:
        flask.abort(403)
    else:
        user = user_matches[0]
        if user.password == request_body['password']:
            print(user.to_json())
            return user.to_json()
        else:
            flask.abort(403)


@app.route('/v1/user/<user_id>', methods=['GET'])
def get_user(user_id: str):
    query = User.objects(id=user_id)
    if query.count() < 1:
        flask.abort(404)
    elif query.count() > 1:
        flask.abort(500)
    db_user = query.first()
    print(f'DB User: {db_user}')
    return json_format.MessageToJson(db_user.to_api())


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=42069, debug=False)
