from mongoengine import *

from backend.model.image import Image
from api.python_api.user_pb2 import User as ApiUser
from .aleaves_model import ALeavesModel


class User(ALeavesModel):
    given_name = StringField()
    family_name = StringField()
    email = EmailField()
    password = StringField()
    friend_ids = ListField(StringField())
    images = EmbeddedDocumentListField(Image)

    def to_api(self):
        api_user = ApiUser()
        api_user.id = str(self.id)
        api_user.given_name = self.given_name
        api_user.family_name = self.family_name
        api_user.email = self.email
        return api_user

