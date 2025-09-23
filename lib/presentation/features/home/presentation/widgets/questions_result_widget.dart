import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/data/datasource/preference/device_preferences.dart';
import 'package:avtotest/data/datasource/preference/settings_preferences.dart';
import 'package:avtotest/data/datasource/preference/subscription_preferences.dart';
import 'package:avtotest/data/datasource/preference/user_preferences.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/test_hint_widget.dart';
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

class QuestionsResultWidget extends StatefulWidget {
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
  State<QuestionsResultWidget> createState() => _QuestionsResultWidgetState();
}

class _QuestionsResultWidgetState extends State<QuestionsResultWidget> {
  late final DevicePreferences _devicePreferences;
  late final SettingsPreferences _settingsPreferences;
  late final SubscriptionPreferences _subscriptionPreferences;
  late final UserPreferences _userPreferences;

  bool _isPrefsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _devicePreferences = await DevicePreferences.getInstance();
    _settingsPreferences = await SettingsPreferences.getInstance();
    _subscriptionPreferences = await SubscriptionPreferences.getInstance();
    _userPreferences = await UserPreferences.getInstance();

    if (mounted) {
      setState(() {
        _isPrefsLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          margin: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(0, 8),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 1,
              color: context.themeExtension.whiteSmokeToWhiteSmoke!,
            ),
          ),
          child: Column(
            children: [
              /// Заголовок + bookmark
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.questionModel.id}-${Strings.question}",
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (widget.onTapBookmark == null) {
                          context.read<QuestionsSolveBloc>().add(
                              BookmarkEvent(question: widget.questionModel));
                        } else {
                          widget.onTapBookmark!();
                        }
                        context.read<HomeBloc>().add(BookmarkedEvent(
                              questionId: widget.questionModel.id,
                              isBookmarked: widget.questionModel.isBookmarked,
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          AppIcons.bookmark,
                          colorFilter: ColorFilter.mode(
                            widget.questionModel.isBookmarked
                                ? AppColors.yellow
                                : context.themeExtension.blackToWhite!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              WDivider(
                indent: 16,
                endIndent: 16,
                color: AppColors.paleGray,
              ),

              /// Текст вопроса
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 8),
                child: WHtml(
                  data: MyFunctions.getQuestionTitle(
                      questionModel: widget.questionModel, lang: lang),
                  textAlign: TextAlign.center,
                  pFontSize: state.questionFontSize,
                  textColor: context.themeExtension.charcoalBlackToWhite!,
                ),
              ),

              const SizedBox(height: 12),

              /// Картинка
              widget.questionModel.media != ""
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => PhotoViewDialog(
                            image: MyFunctions.getAssetsImage(
                                widget.questionModel.media), // png/svg
                            isPngImage: true,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            MyFunctions.getAssetsImage(
                                widget.questionModel.media),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),

              const SizedBox(height: 12),

              /// Ответы
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AnswerWidget(
                    title: MyFunctions.highlightHtmlText(
                        MyFunctions.getAnswerTitle(
                            answerModel: widget.questionModel.answers[index],
                            lang: lang),
                        ''),
                    status: widget.questionModel.answers[index].isCorrect
                        ? AnswerStatus.correct
                        : AnswerStatus.notAnswered,
                    index: index,
                    onTap: () {},
                    answerFontSize: state.answerFontSize,
                  );
                },
                itemCount: widget.questionModel.answers.length,
              ),

              const SizedBox(height: 12),

              if (_isPrefsLoaded)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TestHintWidget(
                    widget.questionModel,
                    devicePreferences: _devicePreferences,
                    settingsPreferences: _settingsPreferences,
                    subscriptionPreferences: _subscriptionPreferences,
                    userPreferences: _userPreferences,
                    isTestScreen: false,
                    index: widget.index, // Pass the index here
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
