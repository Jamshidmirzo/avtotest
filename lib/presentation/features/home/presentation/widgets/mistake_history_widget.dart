import 'dart:developer';

import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class MistakeHistoryWidget extends StatefulWidget {
  const MistakeHistoryWidget({
    super.key,
    required this.model,
    required this.onTap,
  });

  final MistakeQuestionEntity model;
  final VoidCallback onTap;

  @override
  State<MistakeHistoryWidget> createState() => _MistakeHistoryWidgetState();
}

class _MistakeHistoryWidgetState extends State<MistakeHistoryWidget> {
  @override
  void initState() {
    context.read<HomeBloc>().add(GetMistakeHistoryEvent());

    super.initState();
  }

  String formatDateLocalized(String rawDate) {
    try {
      final DateTime date = DateTime.parse(rawDate);
      final DateTime now = DateTime.now();

      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime yesterday = today.subtract(const Duration(days: 1));
      final DateTime inputDate = DateTime(date.year, date.month, date.day);

      final locale = context.locale.languageCode;

      String todayText;
      String yesterdayText;
      log("Locale: $locale");
      switch (locale) {
        case "ru": // Russian
          todayText = "Сегодня";
          yesterdayText = "Вчера";
          break;
        case "uz": // Uzbek Cyrillic
          todayText = "Bugun";
          yesterdayText = "Kecha";
          break;
        case "en": // Uzbek Latin
          todayText = "Бугун";
          yesterdayText = "Кеча";
          break;
        default: // fallback English
          todayText = "Today";
          yesterdayText = "Yesterday";
      }

      if (inputDate == today) {
        return todayText;
      } else if (inputDate == yesterday) {
        return yesterdayText;
      } else {
        return DateFormat('dd.MM.yyyy').format(date);
      }
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            formatDateLocalized(widget.model.date),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 8),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
              color: context.themeExtension.whiteToGondola,
              border: Border.all(
                width: 1,
                color: AppColors.paleGray,
              ),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.existingErrors,
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "${widget.model.attempts.length} ${Strings.taXato}",
                      style: context.textTheme.bodyMedium!.copyWith(
                          color: AppColors.red,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ],
                ),
                Spacer(),
                SvgPicture.asset(
                  AppIcons.arrowRight,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
