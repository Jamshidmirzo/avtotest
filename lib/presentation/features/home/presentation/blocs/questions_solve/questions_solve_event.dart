part of 'questions_solve_bloc.dart';

class QuestionsSolveEvent extends Equatable {
  const QuestionsSolveEvent();

  @override
  List<Object?> get props => [];
}

class InitialQuestionsEvent extends QuestionsSolveEvent {
  const InitialQuestionsEvent({
    this.questions = const [],
    this.time = Duration.zero,
    this.groupId = -1,
    this.lessonId = -1,
    this.isMarathon = false,
  });

  final List<QuestionModel> questions;
  final Duration time;
  final int groupId;
  final int lessonId;
  final bool isMarathon;
}

class LoadQuestionsEvent extends QuestionsSolveEvent {
  final List<QuestionModel> questions;
  LoadQuestionsEvent(this.questions);
}


class ShowTextHintEvent extends QuestionsSolveEvent {
  final QuestionModel question;
  ShowTextHintEvent(this.question);
}

class PauseAudioEvent extends QuestionsSolveEvent {}

class ChangeQuestionIndexEvent extends QuestionsSolveEvent {
  final int newIndex;
  ChangeQuestionIndexEvent(this.newIndex);
}

class InitQuestionsEvent extends QuestionsSolveEvent {
  final List<QuestionModel> questions;

  InitQuestionsEvent(this.questions);
}

class MoveQuestionEvent extends QuestionsSolveEvent {
  const MoveQuestionEvent({
    required this.index,
  });

  final int index;
}

class GetCorrectAnswerEvent extends QuestionsSolveEvent {
  final Function(AnswerModel answer) onSuccess;

  const GetCorrectAnswerEvent({
    required this.onSuccess,
  });
}

class BookmarkEvent extends QuestionsSolveEvent {
  const BookmarkEvent({
    required this.question,
  });

  final QuestionModel question;
}

class QuestionAnsweredEvent extends QuestionsSolveEvent {
  const QuestionAnsweredEvent({
    required this.answerIndex,
    this.isMarathon = false,
    required this.onSuccess,
    required this.onNext,
  });

  final Function(bool isError) onSuccess;
  final int answerIndex;
  final bool isMarathon;
  final Function() onNext;
}

class TimerTickEvent extends QuestionsSolveEvent {}

class AnswerIsFullEvent extends QuestionsSolveEvent {
  const AnswerIsFullEvent({
    required this.onSuccess,
  });

  final Function(bool isFullAnswered) onSuccess;
}

class StopTimerEvent extends QuestionsSolveEvent {
  const StopTimerEvent({
    required this.onStop,
  });

  final Function() onStop;
}

class InsertTicketStatisticsEvent extends QuestionsSolveEvent {}

class InsertTopicStatisticsEvent extends QuestionsSolveEvent {}

class RefreshMarathonEvent extends QuestionsSolveEvent {}

class ShuffleModeEvent extends QuestionsSolveEvent {
  final int index;

  const ShuffleModeEvent({required this.index});
}

class InsertQuestionAttemptsEvent extends QuestionsSolveEvent {}

class RemoveStatisticsErrorEvent extends QuestionsSolveEvent {
  const RemoveStatisticsErrorEvent();
}

class SetDateEvent extends QuestionsSolveEvent {
  const SetDateEvent({
    required this.date,
  });

  final String date;
}
