import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/utils/navigator_extensions.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:avtotest/presentation/widgets/w_radio.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionCountChooseBottomSheet extends StatefulWidget {
  const QuestionCountChooseBottomSheet({super.key});

  @override
  State<QuestionCountChooseBottomSheet> createState() =>
      _QuestionCountChooseBottomSheetState();
}

class _QuestionCountChooseBottomSheetState
    extends State<QuestionCountChooseBottomSheet> {
  late QuestionCount groupValue;

  @override
  void initState() {
    groupValue = QuestionCount.none;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: Strings.selectQuestionNumber,
      hasClose: true,
      hasDivider: false,
      hasTitleHeader: true,
      titleCenter: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              groupValue = QuestionCount.twenty;
            });
          },
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: groupValue == QuestionCount.twenty
                    ? AppColors.vividBlue
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(16),
              color: context.themeExtension.offWhiteBlueTintAshGray,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "20 ${Strings.taSavol}",
                  style: context.textTheme.headlineSmall!.copyWith(),
                ),
                WRadio(
                    onChanged: (item) {
                      setState(() {
                        groupValue = QuestionCount.twenty;
                      });
                    },
                    value: QuestionCount.twenty,
                    groupValue: groupValue)
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              groupValue = QuestionCount.forty;
            });
          },
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: groupValue == QuestionCount.forty
                    ? AppColors.vividBlue
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(16),
              color: context.themeExtension.offWhiteBlueTintAshGray,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "50 ${Strings.taSavol}",
                  style: context.textTheme.headlineSmall!.copyWith(),
                ),
                WRadio(
                    onChanged: (item) {
                      setState(() {
                        groupValue = QuestionCount.forty;
                      });
                    },
                    value: QuestionCount.forty,
                    groupValue: groupValue)
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        WButton(
          isDisabled: groupValue == QuestionCount.none,
          rippleColor: Colors.transparent,
          margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: context.mediaQuery.padding.bottom + 16),
          onTap: () {
            Navigator.of(context).pop();
            context.read<HomeBloc>().add(GetTrainingQuestionsEvent(
                questionCount: groupValue == QuestionCount.twenty ? 20 : 50,
                onSuccess: (List<QuestionModel> questions) {
                  context.rootNavigator.pushPage(TestScreen(
                    questions: questions,
                    title: Strings.preparatoryExam,
                    examType: ExamType.exam,
                    isRealExam45: groupValue == QuestionCount.forty,
                  ));
                }));
          },
          disabledColor: AppColors.offWhiteBlueTint,
          color: AppColors.vividBlue,
          text: Strings.start,
        )
      ],
    );
  }
}

enum QuestionCount {
  twenty,
  forty,
  none,
}
