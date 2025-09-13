part of 'questions_solve_bloc.dart';

class QuestionsSolveState extends Equatable {
  const QuestionsSolveState({
    this.questions = const [],
    this.currentIndex = 0,
    this.oldQuestions = const [],
    this.time = Duration.zero,
    this.totalTime = Duration.zero,
    this.ticketId = -1,
    this.topicId = -1,
    this.date = '',
  });

  final List<QuestionModel> questions;
  final List<QuestionModel> oldQuestions;
  final int currentIndex;
  final Duration time;
  final Duration totalTime;
  final int ticketId;
  final int topicId;
  final String date;

  QuestionsSolveState copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    List<QuestionModel>? oldQuestions,
    Duration? time,
    Duration? totalTime,
    int? ticketId,
    int? topicId,
    String? date,
  }) {
    return QuestionsSolveState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      oldQuestions: oldQuestions ?? this.oldQuestions,
      time: time ?? this.time,
      totalTime: totalTime ?? this.totalTime,
      ticketId: ticketId ?? this.ticketId,
      topicId: topicId ?? this.topicId,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [
        questions,
        currentIndex,
        oldQuestions,
        time,
        totalTime,
        ticketId,
        topicId,
        date,
      ];
}
