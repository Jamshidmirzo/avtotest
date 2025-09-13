import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/features/navigation/domain/entities/navbar.dart';
import 'package:flutter/material.dart';

class NavItemWidget extends StatelessWidget {
  final int currentIndex;
  final NavBar navBar;

  const NavItemWidget({
    required this.navBar,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(0, 10, 0, MediaQuery.paddingOf(context).bottom),
      child: Column(
        children: [
          Center(
            child: currentIndex == navBar.id
                ? Image.asset(
                    navBar.iconActive,
                    width: 20,
                    height: 20,
                  )
                : Image.asset(navBar.iconInactive, width: 20, height: 20),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              navBar.title,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: currentIndex == navBar.id
                  ? Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: context.themeExtension.charcoalBlackToVividBlue)
                  : Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.coolGray),
            ),
          ),
        ],
      ),
    );
  }
}
