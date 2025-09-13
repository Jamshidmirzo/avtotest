import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';

class WRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final Color activeColor;
  final Color? inactiveColor;
  final Color? inactiveBorderColor;

  const WRadio({
    required this.onChanged,
    required this.value,
    required this.groupValue,
    this.inactiveBorderColor,
    this.activeColor = AppColors.blue,
    this.inactiveColor = AppColors.whiteSmoke,
    super.key,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onChanged(value);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color: value == groupValue ? activeColor : inactiveBorderColor ?? const Color(0xffCECECE),
                  width: value == groupValue ? 6 : 2,
                ),
                shape: BoxShape.circle,
                color: value == groupValue ? AppColors.white : context.theme.primaryColor,
              ),
              margin: const EdgeInsets.all(2),
            ),
          ],
        ),
      );
}
