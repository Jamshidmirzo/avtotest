import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/counter_widget.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountersWidget extends StatelessWidget {
  const CountersWidget({
    super.key,
    required this.scrollController,
    required this.carouselSliderController,
    required this.state,
  });

  final ScrollController scrollController;
  final CarouselSliderController carouselSliderController;
  final QuestionsSolveState state;

  TestStatus getTestStatus({
    required QuestionModel questionModel,
    required int currentIndex,
    required int localIndex,
  }) {
    if (questionModel.isAnswered) {
      if (questionModel.errorAnswerIndex == -1) {
        return TestStatus.success;
      } else {
        return TestStatus.error;
      }
    } else {
      if (currentIndex == localIndex) {
        return TestStatus.inProgress;
      } else {
        return TestStatus.notStarted;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                context.read<QuestionsSolveBloc>().add(MoveQuestionEvent(index: index));
                carouselSliderController.animateToPage(index,
                    duration: Duration(milliseconds: 10), curve: Curves.easeInOut);
              },
              child: CounterWidget(
                index: index + 1,
                testStatus: getTestStatus(
                  questionModel: state.questions[index],
                  currentIndex: state.currentIndex,
                  localIndex: index,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 4,
            );
          },
          itemCount: state.questions.length),
    );
  }
}
