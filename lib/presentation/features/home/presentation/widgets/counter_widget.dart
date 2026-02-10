import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget(
      {super.key, required this.index, required this.testStatus});

  final int index;
  final TestStatus testStatus;

  Color getBackgroundColor(BuildContext context) {
    switch (testStatus) {
      case TestStatus.notStarted:
        return context.themeExtension.whiteToGondola!;
      case TestStatus.inProgress:
        return const Color(0xff006FFD); 
      case TestStatus.success:
        return const Color(0xFF00933F);
      case TestStatus.error:
        return const Color(0xFFED3241);
    }
  }

  Color textColor(BuildContext context) {
    switch (testStatus) {
      case TestStatus.notStarted:
        return context.themeExtension.blackToWhite!;
      case TestStatus.inProgress:
        return AppColors.white;
      case TestStatus.success:
        return AppColors.white;
      case TestStatus.error:
        return AppColors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 48,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
          color: getBackgroundColor(context),
          borderRadius: BorderRadius.circular(12),
          border: testStatus == TestStatus.notStarted
              ? Border.all(
                  width: 1,
                  color: context.themeExtension.whiteSmokeToTransparent!)
              : null,
        ),
        child: Text(
          index.toString(),
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textColor(context),
          ),
        ),
      ),
    );
  }
}

enum TestStatus {
  notStarted,
  inProgress,
  success,
  error,
}
