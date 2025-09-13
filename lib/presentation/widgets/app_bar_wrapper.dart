import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final bool hasBackButton;
  final String title;
  final List<Widget>? actions;
  final TextStyle? titleStyle;
  final double elevation;
  final VoidCallback? onTap;

  const AppBarWrapper({
    super.key,
    this.hasBackButton = false,
    required this.title,
    this.actions,
    this.titleStyle,
    this.elevation = 0.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: hasBackButton
          ? IconButton(
              hoverColor: context.theme.hoverColor,
              onPressed: onTap ?? () => Navigator.pop(context),
              icon: SvgPicture.asset(
                AppIcons.chevronLeft,
                colorFilter: ColorFilter.mode(
                  context.themeExtension.blackToWhite!,
                  BlendMode.srcIn,
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: context.textTheme.bodySmall!.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => _getPreferredSize();

  Size _getPreferredSize() {
    final appBarSize = AppBar().preferredSize;
    return appBarSize;
  }
}
