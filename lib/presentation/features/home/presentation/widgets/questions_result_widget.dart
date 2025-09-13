import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/widgets/w_divider.dart';
import 'package:avtotest/presentation/widgets/w_html.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/photo_view_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/answer_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuestionsResultWidget extends StatelessWidget {
  const QuestionsResultWidget({
    super.key,
    required this.questionModel,
    required this.index,
    this.onTapBookmark,
  });

  final QuestionModel questionModel;
  final int index;
  final VoidCallback? onTapBookmark;

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          margin: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 2,
                color: context.themeExtension.whiteSmokeToWhiteSmoke!,
              )),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${questionModel.id}-${Strings.question}",
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (onTapBookmark == null) {
                          context.read<QuestionsSolveBloc>().add(BookmarkEvent(question: questionModel));
                        } else {
                          onTapBookmark!();
                        }
                        context.read<HomeBloc>().add(
                            BookmarkedEvent(questionId: questionModel.id, isBookmarked: questionModel.isBookmarked));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          AppIcons.bookmark,
                          colorFilter: ColorFilter.mode(
                            questionModel.isBookmarked ? AppColors.yellow : context.themeExtension.blackToWhite!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              WDivider(
                indent: 16,
                endIndent: 16,
                color: AppColors.paleGray,
              ),
              Padding(
                padding: EdgeInsets.only(right: 16, left: 16, top: 8),
                child: WHtml(
                  data: MyFunctions.getQuestionTitle(questionModel: questionModel, lang: lang),
                  textAlign: TextAlign.center,
                  pFontSize: state.questionFontSize,
                  textColor: context.themeExtension.charcoalBlackToWhite!,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              questionModel.media != ""
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => PhotoViewDialog(
                            image: MyFunctions.getAssetsImage(questionModel.media), // yoki .svg
                            isPngImage: true, // yoki false
                          ),
                        );
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        //   return PhotoViewScreen(image: MyFunctions.getAssetsImage(questionModel.media));
                        // }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            MyFunctions.getAssetsImage(questionModel.media),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 12,
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AnswerWidget(
                    title: MyFunctions.getAnswerTitle(answerModel: questionModel.answers[index], lang: lang),
                    status: MyFunctions.getAnswerStatus(questionModel: questionModel, index: index),
                    index: index,
                    onTap: () {},
                    answerFontSize: state.answerFontSize,
                  );
                },
                itemCount: questionModel.answers.length,
              ),
            ],
          ),
        );
      },
    );
  }
}
