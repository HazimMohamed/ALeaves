from mongoengine import connect
import os


def get_mongo_password() -> str:
    password_key = 'MONGO_PASS'
    if password_key in os.environ:
        return os.environ[password_key]
    raise Exception('Must set MONGO_PASS environment variable.')


def get_mongo_username() -> str:
    username_key = 'MONGO_USERNAME'
    if username_key in os.environ:
        return os.environ[username_key]
    raise Exception('Must set MONGO_USERNAME environment variable.')


MONGO_URI=f'mongodb+srv://aleaves-service:NI6WBX97J3P6vEdE@centipede.wfahzmu.mongodb.net/aleaves'

connect(host=MONGO_URI)
