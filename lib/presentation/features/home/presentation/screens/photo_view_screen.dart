import 'dart:async';

import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/photo_bottom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewDialog extends StatefulWidget {
  final String image;
  final bool isPngImage;

  const PhotoViewDialog({
    super.key,
    required this.image,
    required this.isPngImage,
  });

  @override
  State<PhotoViewDialog> createState() => _PhotoViewDialogState();
}

class _PhotoViewDialogState extends State<PhotoViewDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: PhotoView.customChild(
          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2.0,
          child: Center(
            // 1. Center удерживает Stack в центре экрана
            child: FutureBuilder<Size>(
              future: _getImageSize(widget.image),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                return AspectRatio(
                  // 2. AspectRatio ограничивает Stack размерами самой картинки
                  aspectRatio: snapshot.data!.width / snapshot.data!.height,
                  child: Stack(
                    children: [
                      // Само фото на весь размер AspectRatio
                      Positioned.fill(
                        child: Image.asset(widget.image, fit: BoxFit.fill),
                      ),

                      // 3. Иконка — теперь bottomRight будет краем ФОТО
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: PhotoBottomWidget()
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Вспомогательная функция для получения размеров ассета
  Future<Size> _getImageSize(String assetPath) async {
    final Image image = Image.asset(assetPath);
    final Completer<Size> completer = Completer<Size>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    return completer.future;
  }
}
