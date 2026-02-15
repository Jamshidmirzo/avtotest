// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/photo_bottom_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/answer_widget.dart';
import 'package:avtotest/presentation/utils/bloc_context_extensions.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/w_html.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/photo_view_screen.dart';

class TestWidget extends StatefulWidget {
  final List<QuestionModel> questions;
  final bool isMarathon;
  final PageController carouselController;

  const TestWidget({
    super.key,
    required this.questions,
    required this.isMarathon,
    required this.carouselController,
  });

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  Timer? _autoNextTimer;

  @override
  void dispose() {
    _autoNextTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;

    return Expanded(
      child: PageView.builder(
        controller: widget.carouselController,
        itemCount: widget.questions.length,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (int index) {
          _autoNextTimer?.cancel();
          context.addBlocEvent<QuestionsSolveBloc>(
            MoveQuestionEvent(index: index),
          );
        },
        itemBuilder: (context, index) {
          return _QuestionItem(
            key: ValueKey('q_${widget.questions[index].id}'),
            question: widget.questions[index],
            index: index,
            lang: lang,
            isMarathon: widget.isMarathon,
            onAnswerTap: (aIndex) => _handleAnswerTap(index, aIndex),
          );
        },
      ),
    );
  }

  void _handleAnswerTap(int qIndex, int aIndex) {
    if (!widget.questions[qIndex].isNotAnswered) return;

    context.addBlocEvent<QuestionsSolveBloc>(
      QuestionAnsweredEvent(
        answerIndex: aIndex,
        isMarathon: widget.isMarathon,
        onSuccess: (bool isError) {
          if (isError) HapticFeedback.mediumImpact();
        },
        onNext: () {
          _autoNextTimer?.cancel();

          // 1. Получаем текущий вопрос после обновления состояния
          final currentQuestion = widget.questions[qIndex];

          // 2. ПРОВЕРКА: Если ответ НЕВЕРНЫЙ, выходим и не скроллим
          // (Используем MyFunctions или проверяем поле корректности в модели)
          final isCorrect = currentQuestion.answers[aIndex].isCorrect;
          if (!isCorrect) return;

          // 3. Если ответ верный, запускаем таймер автоперехода
          final current = context.read<QuestionsSolveBloc>().state.currentIndex;
          if (current >= widget.questions.length - 1) return;

          _autoNextTimer = Timer(const Duration(milliseconds: 800), () {
            if (!mounted) return;
            widget.carouselController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }
}

class _QuestionItem extends StatelessWidget {
  final QuestionModel question;
  final int index;
  final String lang;
  final bool isMarathon;
  final Function(int) onAnswerTap;

  const _QuestionItem({
    super.key,
    required this.question,
    required this.index,
    required this.lang,
    required this.isMarathon,
    required this.onAnswerTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (p, s) =>
          s.questionFontSize != p.questionFontSize ||
          s.answerFontSize != p.answerFontSize,
      builder: (context, state) {
        // Используем CustomScrollView для исключения "прыжков" при скролле
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Заголовок вопроса
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: WHtml(
                  data: MyFunctions.getQuestionTitle(
                    questionModel: question,
                    lang: lang,
                  ),
                  pFontSize: state.questionFontSize,
                  pFontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                  textColor: context.themeExtension.blackToWhite,
                ),
              ),
            ),

            // Изображение
            if (question.media.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildImage(context),
                ),
              ),

            // Список ответов
            SliverPadding(
              padding: EdgeInsets.only(
                top: 12,
                bottom: context.padding.bottom + 24,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, answerIndex) {
                    return AnswerWidget(
                      title: MyFunctions.getAnswerTitle(
                        answerModel: question.answers[answerIndex],
                        lang: lang,
                      ),
                      status: MyFunctions.getAnswerStatus(
                        questionModel: question,
                        index: answerIndex,
                      ),
                      index: answerIndex,
                      answerFontSize: state.answerFontSize,
                      onTap: () => onAnswerTap(answerIndex),
                    );
                  },
                  childCount: question.answers.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage(BuildContext context) {
    final img = MyFunctions.getAssetsImage(question.media);
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: "PhotoView",
          barrierColor: Colors.black.withOpacity(0.60),
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (_, __, ___) => PhotoViewDialog(
            image: img,
            isPngImage: true,
          ),
        );
      },
      child: Stack(
        children: [
          // Само изображение
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Image.asset(
              img,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ),
          // Иконка в углу
          Positioned(
            right: 8,
            top: 8,
            child: PhotoBottomWidget(),
          ),
        ],
      ),
    );
  }
}
