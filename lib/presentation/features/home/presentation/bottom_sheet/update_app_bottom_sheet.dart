import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/data/datasource/network/dto/subscription_response.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';

class UpdateAppBottomSheet extends StatelessWidget {
  final UpdateAppInfo updateAppInfo;

  const UpdateAppBottomSheet({
    super.key,
    required this.updateAppInfo,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: Strings.updateAppTitle,
      hasClose: true,
      hasDivider: false,
      hasTitleHeader: true,
      titleCenter: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            updateAppInfo.isForcedUpdate
                ? Strings.updateAppMessageRequiredUpdate
                : Strings.updateAppMessageOptionalUpdate,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: WButton(
                  rippleColor: Colors.transparent,
                  margin: EdgeInsets.only(bottom: context.mediaQuery.padding.bottom + 16),
                  onTap: () {
                    if(updateAppInfo.isForcedUpdate){
                      MyFunctions.closeApp();
                    }else {
                      Navigator.pop(context);
                    }
                  },
                  color: AppColors.vividBlue,
                  text: Strings.updateAppActionClose,
                  textColor: AppColors.white,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: WButton(
                  rippleColor: Colors.transparent,
                  margin: EdgeInsets.only(bottom: context.mediaQuery.padding.bottom + 16),
                  onTap: () {
                    MyFunctions.openAppStore();
                  },
                  color: AppColors.vividBlue,
                  text: Strings.updateAppActionUpdate,
                  textColor: AppColors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
