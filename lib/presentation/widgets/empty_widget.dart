import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, this.title, this.description});

  final String? title;
  final String? description;

  // final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.inbox),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                title ?? Strings.noDataFound,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineLarge!
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                textAlign: TextAlign.center,
                description ?? "",
                style: context.textTheme.bodyLarge!
                    .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }
}
