import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/counter_widget.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountersWidget extends StatefulWidget {
  const CountersWidget({
    super.key,
    required this.scrollController,
    required this.carouselSliderController,
    required this.state,
  });

  final ScrollController scrollController;
  final PageController carouselSliderController;
  final QuestionsSolveState state;

  @override
  State<CountersWidget> createState() => _CountersWidgetState();
}

class _CountersWidgetState extends State<CountersWidget> {
  final GlobalKey _listViewKey = GlobalKey();
  int? _previousIndex;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.state.currentIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _scrollToActiveItem();
      });
    });
  }

  @override
  void didUpdateWidget(CountersWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.state.currentIndex != widget.state.currentIndex) {
      _previousIndex = oldWidget.state.currentIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToActiveItem();
      });
    }
  }

  void _scrollToActiveItem() {
    if (!widget.scrollController.hasClients) return;

    try {
      final RenderBox? renderBox =
          _listViewKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final currentIndex = widget.state.currentIndex;
      final screenWidth = MediaQuery.of(context).size.width;

      const double itemWidth = 46.0;
      const double separatorWidth = 4.0;
      const double padding = 16.0;

      final double itemPosition =
          padding + (currentIndex * (itemWidth + separatorWidth));
      final double centerOffset = screenWidth / 2;
      final double targetOffset = itemPosition - centerOffset + (itemWidth / 2);

      final maxOffset = widget.scrollController.position.maxScrollExtent;
      final minOffset = widget.scrollController.position.minScrollExtent;

      final clampedOffset = targetOffset.clamp(minOffset, maxOffset);

      widget.scrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      final currentIndex = widget.state.currentIndex;
      final screenWidth = MediaQuery.of(context).size.width;
      final targetOffset = (currentIndex * 50.0) - (screenWidth / 2) + 25;

      widget.scrollController.animateTo(
        targetOffset.clamp(
            0.0, widget.scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  TestStatus getTestStatus({
    required QuestionModel questionModel,
    required int currentIndex,
    required int localIndex,
  }) {
    // ✅ Если выбранный вопрос — всегда синий
    if (currentIndex == localIndex) {
      return TestStatus.inProgress;
    }

    // ✅ Если уже отвечен — проверяем правильность
    if (questionModel.isAnswered) {
      if (questionModel.errorAnswerIndex == -1) {
        return TestStatus.success; // зелёный
      } else {
        return TestStatus.error; // красный
      }
    }

    // ✅ Если ещё не отвечен
    return TestStatus.notStarted; // серый
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: AnimatedBuilder(
        animation: widget.scrollController,
        builder: (context, child) {
          return ListView.separated(
            key: _listViewKey,
            controller: widget.scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context
                      .read<QuestionsSolveBloc>()
                      .add(MoveQuestionEvent(index: index));

                  widget.carouselSliderController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: CounterWidget(
                  index: index + 1,
                  testStatus: getTestStatus(
                    questionModel: widget.state.questions[index],
                    currentIndex: widget.state.currentIndex,
                    localIndex: index,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 4);
            },
            itemCount: widget.state.questions.length,
          );
        },
      ),
    );
  }
}
