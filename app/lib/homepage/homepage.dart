import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aleaves_app/fake_data/fake_users.dart';
import 'package:aleaves_app/homepage/friend_carousel.dart';
import 'package:aleaves_app/homepage/map_view.dart';
import 'package:aleaves_app/service/auth_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'camera_panel.dart';
import '../model/user.dart';
import '../my_images.dart';

const baseUrl = '127.0.0.1:5000';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showCameraView = false;
  User? user;
  CameraPanel? cameraPanel;
  StreamController<bool> takePictureStreamController = StreamController<bool>();
  AuthService authService = AuthService();
  bool _loginLock = false;

  Future<void> _onCameraButtonClicked() async {
    if (!showCameraView) {
      showCameraView = true;
    } else {
      takePictureStreamController.add(true);
      showCameraView = false;
    }
    setState(() {});
  }

  String _encodeImage(Uint8List bytes) {
    return base64Encode(bytes.toList());
  }

  Future<void> _onImageCaptured(XFile file) async {
    final requestBody = jsonEncode({
      'title': 'From flutter image',
      'caption': 'This was sent from the flutter app',
      'latitude': 123.2,
      'longitude': 12321.2,
      'image': _encodeImage(await file.readAsBytes())
    });
    await post(Uri.http(baseUrl, '/v1/user//image'),
        headers: {'Content-Type': 'application/json'}, body: requestBody);
    setState(() {});
  }

  Widget title() {
    return Container(
        margin: const EdgeInsets.only(top: 100),
        child: const Text('ALeaves', style: TextStyle(fontSize: 100)));
  }

  Widget _mainApp() {
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [title(), const MapView()],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCameraButtonClicked,
        tooltip: 'Take a photo',
        child: const Icon(Icons.camera),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void setLoggedInUser(User user) {
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    if (!authService.isUserLoggedIn && !_loginLock) {
      Future.microtask(() => Navigator.pushNamed(context, '/auth/login'));
      _loginLock = true;
    }
    return _mainApp();
  }
}
