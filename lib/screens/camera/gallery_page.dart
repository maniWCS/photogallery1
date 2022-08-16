import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// 1
class GalleryPage extends StatelessWidget {
  final StreamController<List<String>> imageUrlsController;
  // 2
  final VoidCallback shouldLogOut;
  // 3
  final VoidCallback shouldShowCamera;

  GalleryPage(
      {Key? key,
      required this.shouldLogOut,
      required this.shouldShowCamera,
      required this.imageUrlsController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          // 4
          // Log Out Button
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
                child: const Icon(Icons.logout), onTap: shouldLogOut),
          )
        ],
      ),
      // 5
      floatingActionButton: FloatingActionButton(
          onPressed: shouldShowCamera, child: const Icon(Icons.camera_alt)),
      body: Container(child: _galleryGrid()),
    );
  }

  Widget _galleryGrid() {
    return StreamBuilder<List<String>>(
        // 1
        stream: imageUrlsController.stream,
        builder: (context, snapshot) {
          // 2
          if (snapshot.hasData) {
            // 3
            if (snapshot.data!.length > 0) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  // 4
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: snapshot.data![index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator()),
                    );
                  });
            } else {
              // 5
              return const Center(child: Text('No images to display.'));
            }
          } else {
            // 6
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
