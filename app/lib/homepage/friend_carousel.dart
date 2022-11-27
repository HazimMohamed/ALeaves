import 'package:aleaves_app/homepage/image_preview.dart';
import 'package:aleaves_app/model/image.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';

class FriendCarousel extends StatelessWidget {
  User user;

  FriendCarousel({Key? key, required this.user}): super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ImagePreview> imagePreviews = user.images.map((e) => ImagePreview(e)).toList();
    return Column(
      children: [
        Text(user.fullName, textAlign: TextAlign.left),
        Row(
          children: imagePreviews,
        )
      ]);
  }
}