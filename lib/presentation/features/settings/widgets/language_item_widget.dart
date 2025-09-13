import 'package:avtotest/domain/model/language/language.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/w_radio.dart';
import 'package:flutter/material.dart';

class LanguageItemWidget extends StatelessWidget {
  const LanguageItemWidget({
    super.key,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  final Language groupValue;
  final Language value;

  final Function(Language language) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 16, top: 16, bottom: 16),
        child: Row(
          children: [
            Text(
              value.languageName,
              style: context.textTheme.headlineSmall!.copyWith(
                color: context.themeExtension.charcoalBlackToWhite,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            WRadio(
              onChanged: onChanged,
              value: value,
              groupValue: groupValue,
            )
          ],
        ),
      ),
    );
  }
}
