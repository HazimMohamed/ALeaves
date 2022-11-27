from mongoengine import *


class Image(EmbeddedDocument):
    id = ObjectIdField()
    title = StringField()
    caption = StringField()
    uri = StringField()
    latitude = FloatField()
    longitude = FloatField()