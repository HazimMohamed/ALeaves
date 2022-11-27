void checkJsonContains(String fieldName, dynamic jsonObject) {
  if (jsonObject[fieldName] == null) {
    throw 'Received response from backend without expected field $fieldName';
  }
}