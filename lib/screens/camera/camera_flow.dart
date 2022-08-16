import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:photogallery1/screens/camera/camera_page.dart';
import 'package:photogallery1/screens/camera/gallery_page.dart';

import '../../services/storage_service.dart';

class CameraFlow extends StatefulWidget {
  // 1
  final VoidCallback shouldLogOut;

  CameraFlow({Key? key, required this.shouldLogOut}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow> {
  late CameraDescription _camera;
  // 2
  bool _shouldShowCamera = false;
  late StorageService _storageService;

  // 3
  List<MaterialPage> get _pages {
    return [
      // Show Gallery Page
      MaterialPage(
          child: GalleryPage(
        shouldLogOut: widget.shouldLogOut,
        shouldShowCamera: () => _toggleCameraOpen(true),
        imageUrlsController: _storageService.imageUrlsController,
      )),

      // Show Camera Page
      if (_shouldShowCamera)
        MaterialPage(
            child: CameraPage(
                camera: _camera,
                didProvideImagePath: (imagePath) {
                  this._toggleCameraOpen(false);
                  this._storageService.uploadImageAtPath(imagePath);
                }))
    ];
  }

  @override
  void initState() {
    super.initState();
    _getCamera();
    _storageService = StorageService();
    _storageService.getImages();
  }

  @override
  Widget build(BuildContext context) {
    // 4
    return Navigator(
      pages: _pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  // 5
  void _toggleCameraOpen(bool isOpen) {
    setState(() {
      this._shouldShowCamera = isOpen;
    });
  }

  void _getCamera() async {
    final camerasList = await availableCameras();
    setState(() {
      final firstCamera = camerasList.first;
      this._camera = firstCamera;
    });
  }
}
