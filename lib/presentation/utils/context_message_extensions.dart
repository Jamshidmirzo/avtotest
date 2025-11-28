import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

extension ContextMessageExtensions on BuildContext {
  void showSnackBar(
    String message, {
    int durationInSeconds = 3,
    DelightSnackbarPosition position = DelightSnackbarPosition.bottom,
    autoDismiss = true,
    TextStyle? style,
  }) {
    DelightToastBar(
      snackbarDuration: Duration(seconds: durationInSeconds),
      position: position,
      autoDismiss: autoDismiss,
      builder: (context) => ToastCard(
        title: Padding(
          padding: const EdgeInsets.only(right: 70), // 👈 padding berildi
          child: Center(
            child: Text(
              message,
              style: style ??
                  const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
            ),
          ),
        ),
      ),
    ).show(this);
  }

  void showInfoSnackBar(
    String message, {
    DelightSnackbarPosition position = DelightSnackbarPosition.top,
  }) {
    showSnackBar(message, position: position);
  }

  void showErrorSnackBar(
    String message, {
    durationInSeconds = 5,
    autoDismiss = true,
    DelightSnackbarPosition position = DelightSnackbarPosition.top,
  }) {
    showSnackBar(
      message,
      durationInSeconds: durationInSeconds,
      autoDismiss: autoDismiss,
      position: position,
      style: TextStyle(
          color: Theme.of(this).brightness == Brightness.dark
              ? Colors.white // dark rejimda oq
              : Colors.black, // light rejimda qora
          fontWeight: FontWeight.w600,
          fontSize: 14),
    );
  }
}
