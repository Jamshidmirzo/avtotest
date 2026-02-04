part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class ParseQuestionsEvent extends HomeEvent {
  const ParseQuestionsEvent();
}

class SetLoadingStateEvent extends HomeEvent {
  final bool isLoading;

  const SetLoadingStateEvent({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class GetBookmarksEvent extends HomeEvent {
  const GetBookmarksEvent();
}

class ParseTopicsEvent extends HomeEvent {
  const ParseTopicsEvent();
}

class InitializeSearchEvent extends HomeEvent {
  const InitializeSearchEvent();
}
class GetOrderedQuestionsEvent extends HomeEvent {
  final int questionCount; // если 0 или меньше — вернёт все вопросы
  final void Function(List<QuestionModel>) onSuccess;

  const GetOrderedQuestionsEvent({
    required this.questionCount,
    required this.onSuccess,
  });
}



class SearchQuestionEvent extends HomeEvent {
  final String query;

  const SearchQuestionEvent({required this.query});
}

class BookmarkedEvent extends HomeEvent {
  final int questionId;
  final bool isBookmarked;

  const BookmarkedEvent({
    required this.questionId,
    required this.isBookmarked,
  });
}

class DeleteBookmarksEvent extends HomeEvent {
  const DeleteBookmarksEvent();
}

class GetTicketsStatisticsEvent extends HomeEvent {
  const GetTicketsStatisticsEvent();
}

class GetTicketQuestionEvent extends HomeEvent {
  final int ticketId;
  final Function(List<QuestionModel> questions) onSuccess;

  const GetTicketQuestionEvent({required this.onSuccess, required this.ticketId});
}

class GetTopicQuestionsEvent extends HomeEvent {
  final int topicId;
  final Function(List<QuestionModel> questions) onSuccess;

  const GetTopicQuestionsEvent({
    required this.topicId,
    required this.onSuccess,
  });
}

class GetTrainingQuestionsEvent extends HomeEvent {
  final int questionCount;
  final Function(List<QuestionModel> questions) onSuccess;

  const GetTrainingQuestionsEvent({
    required this.questionCount,
    required this.onSuccess,
  });
}

class GetDistractionQuestionsEvent extends HomeEvent {
  final Function(List<QuestionModel> questions) onSuccess;

  const GetDistractionQuestionsEvent({
    required this.onSuccess,
  });
}

class GetRealExamQuestionsEvent extends HomeEvent {
  final Function(List<QuestionModel> questions) onSuccess;

  const GetRealExamQuestionsEvent({
    required this.onSuccess,
  });
}

class GetMarathonQuestionsEvent extends HomeEvent {
  final Function(List<QuestionModel> questions) onSuccess;

  const GetMarathonQuestionsEvent({
    required this.onSuccess,
  });
}

class DeleteTicketStatisticsEvent extends HomeEvent {}

class DeleteTopicStatisticsEvent extends HomeEvent {
  const DeleteTopicStatisticsEvent();
}

class GetMistakeHistoryEvent extends HomeEvent {
  const GetMistakeHistoryEvent();
}

class DeleteMistakeHistoryEvent extends HomeEvent {
  const DeleteMistakeHistoryEvent();
}

class GetMistakeQuestionsEvent extends HomeEvent {
  const GetMistakeQuestionsEvent({
    required this.onSuccess,
    required this.attempts,
    required this.isView,
  });

  final bool isView;
  final List<QuestionAttemptEntity> attempts;
  final Function(List<QuestionModel> questions) onSuccess;
}

class ChangeQuestionFontSize extends HomeEvent {
  final int questionFontSize;

  const ChangeQuestionFontSize({
    required this.questionFontSize,
  });
}

class ChangeAnswerFontSize extends HomeEvent {
  final int answerFontSize;

  const ChangeAnswerFontSize({
    required this.answerFontSize,
  });
}

class LoadFontSizeEvent extends HomeEvent {
  const LoadFontSizeEvent();
}
