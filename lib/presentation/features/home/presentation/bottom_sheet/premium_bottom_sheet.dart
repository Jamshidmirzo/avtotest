import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 Clipboard uchun kerak

class PremiumBottomSheet extends StatelessWidget {
  final int userId;
  final VoidCallback onClickOpenTelegram;

  const PremiumBottomSheet({
    super.key,
    required this.userId,
    required this.onClickOpenTelegram,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: Strings.premiumSubscriptionTitle,
      hasClose: true,
      hasDivider: false,
      hasTitleHeader: true,
      titleCenter: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            textAlign: TextAlign.center,
            Strings.premiumSubscriptionMessage,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ID: $userId",
                style: const TextStyle(
                  color: AppColors.vividBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.copy,
                    size: 18,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.black),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: userId.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("ID nusxalandi")),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: WButton(
                  rippleColor: Colors.transparent,
                  margin: EdgeInsets.only(
                      bottom: context.mediaQuery.padding.bottom + 16),
                  onTap: () {
                    Navigator.pop(context);
                    MyFunctions.launchTelegramForSubscriptionRequest(id: "");
                  },
                  color: AppColors.vividBlue,
                  text: Strings.premiumSubscriptionOpenTelegram,
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
