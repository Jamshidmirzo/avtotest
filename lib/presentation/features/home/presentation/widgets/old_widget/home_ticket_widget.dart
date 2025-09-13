import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeTicketWidget extends StatelessWidget {
  const HomeTicketWidget({super.key, required this.onTap, required this.count});

  final VoidCallback onTap;
  final String count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16),
        child: Stack(
          children: [
            SvgPicture.asset(
              AppIcons.biletBackground,
              width: (context.mediaQuery.size.width - 40) / 2,
            ),
            Positioned(
              right: 16,
              top: 16,
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(180),
                  color: AppColors.white.withValues(alpha: 0.3),
                ),
                child: SvgPicture.asset(
                  AppIcons.leftAction,
                  colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.all,
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Color(0xffA7BDFF),
                    ),
                  ),
                  Text(
                    Strings.ticket,
                    style: context.textTheme.headlineSmall!
                        .copyWith(fontWeight: FontWeight.w800, fontSize: 22, color: AppColors.white),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: count,
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        color: AppColors.white,
                      ),
                    ),
                    WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                      text: "ta",
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                    )
                  ])),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
