import 'package:aleaves_app/model/image.dart';
import 'package:aleaves_app/model/parsing_utils.dart';

class User {
  String? id;

  String givenName;

  String familyName;

  String emailAddress;

  List<ALeavesImage> images;

  String get fullName => '$givenName $familyName';

  User(
      {
      this.id,
      required this.givenName,
      required this.familyName,
      required this.emailAddress,
      required this.images});

  static User fromJson(dynamic jsonUser) {
    checkJsonContains('given_name', jsonUser);
    checkJsonContains('family_name', jsonUser);
    checkJsonContains('email', jsonUser);
    checkJsonContains('images', jsonUser);

    return User(
        id: jsonUser['_id']['\$oid'],
        givenName: jsonUser['given_name'],
        familyName: jsonUser['family_name'],
        emailAddress: jsonUser['email'],
        images: (jsonUser['images'] as List).cast<ALeavesImage>());
  }
}
