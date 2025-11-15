part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState( {
    this.originalQuestions = const [],
    this.questions = const [],
    this.distractionQuestions = const [],
    this.searchQuestions = const [],
    this.bookmarks = const [],
    this.ticketsStatistics = const [],
    this.topics = const [],
    this.marathonQuestions = const [],
    this.questionFontSize = 16,
    this.answerFontSize = 15,
    this.solveQuestionCount = 0,
    this.mistakeQuestions = const [],
    this.totalCount = 0,
    this.isLoading = false,
  });
final List<QuestionModel> originalQuestions;
  final List<QuestionModel> questions;
  final List<QuestionModel> distractionQuestions;
  final List<QuestionModel> searchQuestions;
  final List<QuestionModel> bookmarks;
  final List<TicketStatisticsEntity> ticketsStatistics;
  final List<TopicModel> topics;
  final List<QuestionModel> marathonQuestions;
  final int questionFontSize;
  final int answerFontSize;
  final int solveQuestionCount;
  final int totalCount;
  final List<MistakeQuestionEntity> mistakeQuestions;
  final bool isLoading;

 HomeState copyWith({
  List<QuestionModel>? questions,
  List<QuestionModel>? originalQuestions, // <-- новое поле
  List<QuestionModel>? searchQuestions,
  List<QuestionModel>? distractionQuestions,
  List<QuestionModel>? bookmarks,
  List<TicketStatisticsEntity>? ticketsStatistics,
  List<TopicModel>? topics,
  List<QuestionModel>? marathonQuestions,
  int? questionFontSize,
  int? answerFontSize,
  int? solveQuestionCount,
  List<MistakeQuestionEntity>? mistakeQuestions,
  int? totalCount,
  bool? isLoading,
}) {
  return HomeState(
    questions: questions ?? this.questions,
    originalQuestions: originalQuestions ?? this.originalQuestions, // <-- новое поле
    distractionQuestions: distractionQuestions ?? this.questions,
    searchQuestions: searchQuestions ?? this.searchQuestions,
    bookmarks: bookmarks ?? this.bookmarks,
    ticketsStatistics: ticketsStatistics ?? this.ticketsStatistics,
    topics: topics ?? this.topics,
    marathonQuestions: marathonQuestions ?? this.marathonQuestions,
    questionFontSize: questionFontSize ?? this.questionFontSize,
    answerFontSize: answerFontSize ?? this.answerFontSize,
    solveQuestionCount: solveQuestionCount ?? this.solveQuestionCount,
    mistakeQuestions: mistakeQuestions ?? this.mistakeQuestions,
    totalCount: totalCount ?? this.totalCount,
    isLoading: isLoading ?? this.isLoading,
  );
}

  @override
List<Object?> get props => [
      questions,
      originalQuestions, // <-- добавлено
      searchQuestions,
      bookmarks,
      ticketsStatistics,
      topics,
      marathonQuestions,
      questionFontSize,
      answerFontSize,
      solveQuestionCount,
      mistakeQuestions,
      totalCount,
      isLoading,
    ];

}

class MistakeQuestionEntity {
  final String date;
  final List<QuestionAttemptEntity> attempts;

  MistakeQuestionEntity({
    required this.date,
    required this.attempts,
  });

  MistakeQuestionEntity copyWith({
    String? date,
    List<QuestionAttemptEntity>? attempts,
  }) {
    return MistakeQuestionEntity(
      date: date ?? this.date,
      attempts: attempts ?? this.attempts,
    );
  }
}
