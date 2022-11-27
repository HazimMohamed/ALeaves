from abc import ABC, abstractmethod

from mongoengine.document import Document


# Abstract
class ALeavesModel(Document, ABC):

    @abstractmethod
    def to_api(self):
        raise AssertionError('to_api not overridden')

    def __str__(self):
        string_rep = f'{self.__class__}\n'
        for field_name in self:
            string_rep += f'{field_name} : {self[field_name]}\n'
        return string_rep

    __repr__ = __str__
