import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/widgets/w_divider.dart';
import 'package:avtotest/presentation/widgets/w_html.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/photo_view_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/answer_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuestionSearchWidget extends StatelessWidget {
  const QuestionSearchWidget({
    super.key,
    required this.questionModel,
    this.highlightText = "",
  });

  final QuestionModel questionModel;
  final String highlightText;

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.questionFontSize != current.questionFontSize ||
          previous.answerFontSize != current.answerFontSize,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          margin: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(

              // color: context.themeExtension.paleBlueToCharcoalBlack,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1,
                color: context.themeExtension.whiteSmokeToWhiteSmoke!,
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${questionModel.id}-Savol",
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<HomeBloc>().add(
                              BookmarkedEvent(
                                questionId: questionModel.id,
                                isBookmarked: questionModel.isBookmarked,
                              ),
                            );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          AppIcons.bookmark,
                          colorFilter: ColorFilter.mode(
                              questionModel.isBookmarked
                                  ? AppColors.yellow
                                  : context.themeExtension.blackToWhite!,
                              BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              WDivider(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 4),
                child: WHtml(
                  data: MyFunctions.highlightHtmlText(
                      MyFunctions.getTitle(questionModel, lang), highlightText),
                  textAlign: TextAlign.center,
                  pFontWeight: FontWeight.w700,
                  pFontSize: state.questionFontSize,
                  textColor: context.themeExtension.blackToWhite,
                ),
              ),
              questionModel.media.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => PhotoViewDialog(
                            image: MyFunctions.getAssetsImage(
                                questionModel.media), // yoki .svg
                            isPngImage: true, // yoki false
                          ),
                        );
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        //   return PhotoViewScreen(image: MyFunctions.getAssetsImage(questionModel.media));
                        // }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ).copyWith(top: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            MyFunctions.getAssetsImage(questionModel.media),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 12,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AnswerWidget(
                    title: MyFunctions.highlightHtmlText(
                        MyFunctions.getAnswerTitle(
                            answerModel: questionModel.answers[index],
                            lang: lang),
                        highlightText),
                    status: questionModel.answers[index].isCorrect
                        ? AnswerStatus.correct
                        : AnswerStatus.notAnswered,
                    index: index,
                    onTap: () {},
                    answerFontSize: state.answerFontSize,
                  );
                },
                itemCount: questionModel.answers.length,
                physics: NeverScrollableScrollPhysics(),
              ),
            ],
          ),
        );
      },
    );
  }
}
