import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/tappable_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsItemWidget extends StatelessWidget {
  const SettingsItemWidget({
    super.key,
    required this.title,
    required this.iconPath,
    this.hasSwitch = false,
    required this.onChange,
    required this.onTap,
    this.isSwitched = false,
    this.widget,
  });

  final String title;
  final String iconPath;
  final bool hasSwitch;
  final Function(bool onchange) onChange;
  final VoidCallback onTap;
  final bool isSwitched;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      onTap: onTap,
      context: context,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            SvgPicture.asset(iconPath),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                title,
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.themeExtension.charcoalBlackToWhite,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget != null) widget!,
            if (hasSwitch)
              CupertinoSwitch(
                value: isSwitched,
                onChanged: onChange,
                activeTrackColor: AppColors.vividBlue,
              ),
          ],
        ),
      ),
    );
  }
}
