import 'package:flutter/material.dart';

import '../model/image.dart';


class ImagePreview extends StatelessWidget{
  ALeavesImage image;
  
  ImagePreview(this.image);

  @override
  Widget build(BuildContext context) {
    return Card(child: Image.network(image.url, width: 100, height: 100,));
  }
  
}