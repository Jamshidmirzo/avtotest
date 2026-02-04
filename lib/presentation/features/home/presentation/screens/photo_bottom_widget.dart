import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PhotoBottomWidget extends StatelessWidget {
  const PhotoBottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => MyFunctions.shareAppLink(context),
      child: Container(
        width: 30.w,
        height: 30.h,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          AppIcons.appIcon,
          width: 12.w,
          height: 12.h,
        ),
      ),
    );
  }
}
