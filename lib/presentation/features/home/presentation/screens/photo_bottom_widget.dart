import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PhotoBottomWidget extends StatelessWidget {
  const PhotoBottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black
                    .withOpacity(0.5), // Полупрозрачный фон для видимости
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(AppIcons.pro),
            );
  }
}