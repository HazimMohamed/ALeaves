import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPanel extends StatefulWidget {
  final Stream<bool>? takePhotoStream;
  final void Function(XFile)? onImageCaptured;

  CameraPanel({Key? key, this.takePhotoStream, this.onImageCaptured}) : super(key: key);

  @override
  State createState() {
    return _CameraPanelState();
  }
}

class _CameraPanelState extends State<CameraPanel> {
  late Future<CameraController> _cameraControllerFuture;

  Future<CameraController> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw 'Could not find any cameras';
    }
    final camera = cameras[0];
    final cameraController = CameraController(camera, ResolutionPreset.low);
    await cameraController.initialize();
    return cameraController;
  }

  void _capturePhoto(bool unused) async {
    final cameraController = await _cameraControllerFuture;
    final image = await cameraController.takePicture();
    if (widget.onImageCaptured != null) {
      widget.onImageCaptured!(image);
    }
  }

  @override
  void initState() {
    super.initState();

    _cameraControllerFuture = _initCamera();
    if (widget.takePhotoStream != null) {
      widget.takePhotoStream!.listen(_capturePhoto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cameraControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<CameraController> result) {
        if (result.hasData) {
          final controller = result.data!;
          return AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller));
        } else if (result.hasError) {
          return Text(result.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}