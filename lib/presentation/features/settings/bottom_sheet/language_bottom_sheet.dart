import 'package:avtotest/domain/model/language/language.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_divider.dart';
import 'package:avtotest/presentation/features/settings/widgets/language_item_widget.dart';
import 'package:flutter/material.dart';

class LanguageBottomSheet extends StatelessWidget {
  final Language selectedLanguage;
  final Function(Language language) onChanged;

  const LanguageBottomSheet({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: "",
      hasDivider: false,
      hasTitleHeader: true,
      hasClose: true,
      children: [
        LanguageItemWidget(
          groupValue: selectedLanguage,
          value: Language.uzbekLatin,
          onChanged: (Language language) {
            onChanged(language);
            Navigator.pop(context, language);
          },
        ),
        WDivider(
          indent: 16,
          endIndent: 16,
          thickness: 0.5,
        ),
        LanguageItemWidget(
          groupValue: selectedLanguage,
          value: Language.russianRu,
          onChanged: (Language language) {
            onChanged(language);
            Navigator.pop(context, language);
          },
        ),
        WDivider(
          indent: 16,
          endIndent: 16,
        ),
        LanguageItemWidget(
          groupValue: selectedLanguage,
          value: Language.uzbekCyrill,
          onChanged: (Language language) {
            onChanged(language);
            Navigator.pop(context, language);
          },
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }
}
