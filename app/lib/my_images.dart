import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;


class MyImages extends StatefulWidget {
  MyImages({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyImagesState();
  }
}

class _MyImagesState extends State<MyImages> {

  Future<List<Image>> _getUsersImages() async {
    final response = await http.get(
        Uri.http('1234', '/v1/user/'));
    if (response.statusCode != 200) {
      throw 'Received status code ${response.statusCode}. Error: ${response
          .body}';
    }
    final responseBody = jsonDecode(response.body);
    final responseImages = responseBody['images'];
    List<Image> images = [];
    for (var image in responseImages) {
      final imageUrl = 'http://${image['uri']}';
      images.add(Image.network(imageUrl));
    }
    return images;
  }

  Widget _renderAfterImagesFetched(BuildContext context, AsyncSnapshot<List<Image>> snapshot) {
    if (snapshot.hasData) {
      return Column(
          children: snapshot.data!
      );
    } else if (snapshot.hasError) {
      return Center(child: Text(snapshot.error.toString()));
    }
    return const CircularProgressIndicator();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return FutureBuilder(future: _getUsersImages(), builder: _renderAfterImagesFetched);
  }
}