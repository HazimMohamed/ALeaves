import 'package:flutter/cupertino.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  
  @override
  Widget build(BuildContext context) {
    return Image.network('https://joomly.net/frontend/web/images/googlemap/map.png');
  }
}
