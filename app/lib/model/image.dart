import 'package:aleaves_app/model/parsing_utils.dart';

class ALeavesImage {
  String url;

  num latitude;

  num longitude;

  String caption;

  ALeavesImage(
      {required this.url,
      required this.caption,
      required this.latitude,
      required this.longitude});

  static ALeavesImage fromJson(dynamic jsonImage) {
    checkJsonContains('url', jsonImage);
    checkJsonContains('latitude', jsonImage);
    checkJsonContains('longitude', jsonImage);
    checkJsonContains('caption', jsonImage);

    return ALeavesImage(
        url: jsonImage['url'],
        latitude: jsonImage['latitude'],
        longitude: jsonImage['longitude'],
        caption: jsonImage['caption']);
  }
}
