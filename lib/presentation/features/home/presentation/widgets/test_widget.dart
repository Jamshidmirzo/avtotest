import 'dart:async';

import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/answer_widget.dart';
import 'package:avtotest/presentation/utils/bloc_context_extensions.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/w_html.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/photo_view_screen.dart';

class TestWidget extends StatefulWidget {
  final List<QuestionModel> questions;
  final bool isMarathon;

  const TestWidget({
    super.key,
    required this.questions,
    required this.isMarathon,
  });

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  Timer? _autoNextTimer;

  @override
  void dispose() {
    _autoNextTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final lang = context.locale.languageCode;
    return Expanded(
      child: _buildCarouselSlider(lang, height, context),
    );
  }

  CarouselSlider _buildCarouselSlider(
    String lang,
    double height,
    BuildContext context,
  ) {
    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: widget.questions.length,
      itemBuilder: (context, carouselIndex, realIndex) {
        return _buildBlocBuilder(carouselIndex, lang);
      },
      options: CarouselOptions(
        height: height,
        enlargeCenterPage: false,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        scrollPhysics: const BouncingScrollPhysics(),
        onPageChanged: (int index, CarouselPageChangedReason reason) {
          if (reason == CarouselPageChangedReason.manual) {
            _autoNextTimer?.cancel();
          }
          context.addBlocEvent<QuestionsSolveBloc>(
            MoveQuestionEvent(index: index),
          );
        },
      ),
    );
  }

  BlocBuilder<HomeBloc, HomeState> _buildBlocBuilder(
    int carouselIndex,
    String lang,
  ) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (state, previous) =>
          state.questionFontSize != previous.questionFontSize ||
          state.answerFontSize != previous.answerFontSize,
      builder: (context, state) {
        return BounceScrollWrapper(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildQuestionTitle(context, state, carouselIndex, lang),
                const SizedBox(height: 12),
                _buildQuestionImage(context, carouselIndex),
                const SizedBox(height: 20),
                _buildVariantList(context, carouselIndex, lang, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Padding _buildQuestionTitle(
    BuildContext context,
    HomeState state,
    int carouselIndex,
    String lang,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: WHtml(
        data: MyFunctions.getQuestionTitle(
          questionModel: widget.questions[carouselIndex],
          lang: lang,
        ),
        pFontSize: state.questionFontSize,
        pFontWeight: FontWeight.w700,
        textAlign: TextAlign.center,
        textColor: context.themeExtension.blackToWhite,
      ),
    );
  }

  Widget _buildQuestionImage(BuildContext context, int carouselIndex) {
    final media = widget.questions[carouselIndex].media;
    if (media.isEmpty) return const SizedBox();

    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: "PhotoView",
          barrierColor: Colors.black.withOpacity(0.95),
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (_, __, ___) => PhotoViewDialog(
            image: MyFunctions.getAssetsImage(media),
            isPngImage: true,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Image.asset(MyFunctions.getAssetsImage(media)),
        ),
      ),
    );
  }

  ListView _buildVariantList(
    BuildContext context,
    int carouselIndex,
    String lang,
    HomeState state,
  ) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: context.padding.bottom + 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.questions[carouselIndex].answers.length,
      itemBuilder: (context, index) {
        return _buildVariantItem(carouselIndex, index, lang, context, state);
      },
    );
  }

  AnswerWidget _buildVariantItem(
    int carouselIndex,
    int index,
    String lang,
    BuildContext context,
    HomeState state,
  ) {
    return AnswerWidget(
      title: MyFunctions.getAnswerTitle(
        answerModel: widget.questions[carouselIndex].answers[index],
        lang: lang,
      ),
      status: MyFunctions.getAnswerStatus(
        questionModel: widget.questions[carouselIndex],
        index: index,
      ),
      index: index,
      onTap: () {
        if (widget.questions[carouselIndex].isNotAnswered) {
          context.addBlocEvent<QuestionsSolveBloc>(
            QuestionAnsweredEvent(
              answerIndex: index,
              isMarathon: widget.isMarathon,
              onSuccess: (bool isError) {
                if (isError) HapticFeedback.mediumImpact();
              },
              onNext: () {
                _autoNextTimer?.cancel();
                final currentIndex =
                    context.read<QuestionsSolveBloc>().state.currentIndex;
                if (currentIndex >= widget.questions.length - 1) return;
                _autoNextTimer = Timer(const Duration(milliseconds: 800), () {
                  if (!mounted) return;
                  _carouselController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                });
              },
            ),
          );
        }
      },
      answerFontSize: state.answerFontSize,
    );
  }
}

class BounceScrollWrapper extends StatelessWidget {
  final Widget child;
  const BounceScrollWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollNotification>(
      onNotification: (overscroll) {
        return true; // Prevent overscroll
      },
      child: ScrollConfiguration(
        behavior: const _NoGlowBehavior(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: child,
        ),
      ),
    );
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child; // Remove glow effect
  }
}