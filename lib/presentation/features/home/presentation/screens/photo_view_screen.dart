// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewDialog extends StatelessWidget {
  final String image;
  final bool isPngImage;
  const PhotoViewDialog({
    super.key,
    required this.image,
    required this.isPngImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) {
            Navigator.of(context).pop();
          }
        },
        child: Center(
          child: PhotoView(
            imageProvider: AssetImage(image),
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
