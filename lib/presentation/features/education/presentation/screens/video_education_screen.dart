import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/video_screen.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class VideoEducationScreen extends StatelessWidget {
  const VideoEducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBarWrapper(
        title: 'Barcha biletlar',
        hasBackButton: true,
      ),
      body: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, index) => SizedBox(
              height: 10.h,
            ),
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImprovedVideoPlayer(
                        videoId: '0038e23a-eace-4930-a91f-fe0d3d1ea6d6',
                      ),
                    )),
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 68.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.themeExtension.whiteToGondola,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(width: 1, color: Color(0xFFC4C4C4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Color(0xFF0050EF),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: SvgPicture.asset(AppIcons.play),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${index + 1}-Bilet',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0050EF),
                            ),
                          ),
                          Text(
                            'Video darslik',
                            style: TextStyle(
                              color: isDark ? Colors.white : Color(0xFF8F9098),
                              fontSize: 12.sp,
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      Text(
                        '10:00',
                        style: TextStyle(
                          color: isDark ? Colors.white : Color(0xFF8F9098),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}

class AppBarIconBox extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AppBarIconBox({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8E9F1)),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
