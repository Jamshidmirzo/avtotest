import 'dart:convert';
import 'dart:math';

import 'package:avtotest/content/groups.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/data/datasource/di/service_locator.dart';
import 'package:avtotest/data/datasource/storage/storage.dart';
import 'package:avtotest/data/datasource/storage/storage_keys.dart';
import 'package:avtotest/presentation/features/home/data/entity/bookmark_entity.dart';
import 'package:avtotest/presentation/features/home/data/entity/question_attempt_entity.dart';
import 'package:avtotest/presentation/features/home/data/entity/ticket_statistics_entity.dart';
import 'package:avtotest/presentation/features/home/data/entity/topic_statistics_entity.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/data/model/topic_model.dart';
import 'package:avtotest/presentation/features/home/data/repository/bookmark_repository.dart';
import 'package:avtotest/presentation/features/home/data/repository/question_attempt_repository.dart';
import 'package:avtotest/presentation/features/home/data/repository/ticket_repository.dart';
import 'package:avtotest/presentation/features/home/data/repository/topic_repository.dart';
import 'package:avtotest/questions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BookmarkRepository bookmarkRepository =
      serviceLocator<BookmarkRepository>();
  final QuestionAttemptRepository questionAttemptRepository =
      serviceLocator<QuestionAttemptRepository>();
  final TopicRepository topicRepository = serviceLocator<TopicRepository>();
  final TicketRepository ticketRepository = serviceLocator<TicketRepository>();

  HomeBloc() : super(HomeState()) {
    // parse questions and topics
    on<ParseQuestionsEvent>(_onParseQuestionsEvent);
    on<ParseTopicsEvent>(_onParseTopicsEvent);
    // bookmark
    on<GetBookmarksEvent>(_onGetBookmarkEvent);
    on<BookmarkedEvent>(_onBookmarkedEvent);
    on<DeleteBookmarksEvent>(_onDeleteBookmarksEvent);
    // search
    on<SearchQuestionEvent>(_onSearchQuestionEvent);
    on<InitializeSearchEvent>(_onInitializeSearchEvent);

    on<GetTicketsStatisticsEvent>(_onGetTicketsStatisticsEvent);
    on<GetTicketQuestionEvent>(_onGetTicketQuestionEvent);
    on<GetTopicQuestionsEvent>(_onGetTopicQuestionsEvent);
    //
    on<GetTrainingQuestionsEvent>(_onGetTrainingQuestionsEvent);
    on<GetDistractionQuestionsEvent>(_onGetDistractionQuestionsEvent);
    on<GetRealExamQuestionsEvent>(_onGetRealExamQuestionsEvent);
    on<GetMarathonQuestionsEvent>(_onGetMarathonQuestionsEvent);
    on<DeleteTicketStatisticsEvent>(_onDeleteTicketStatisticsEvent);
    on<DeleteTopicStatisticsEvent>(_onDeleteTopicStatisticsEvent);
    // question attempts
    on<GetMistakeHistoryEvent>(_onGetMistakeHistoryEvent);
    on<DeleteMistakeHistoryEvent>(_onDeleteMistakeHistoryEvent);
    on<GetMistakeQuestionsEvent>(_onGetMistakeQuestionsEvent);
    // font
    on<ChangeAnswerFontSize>(_onChangeAnswerFontSize);
    on<ChangeQuestionFontSize>(_onChangeQuestionFontSize);
    on<LoadFontSizeEvent>(_onLoadFontSizeEvent);
    on<GetOrderedQuestionsEvent>(_onGetOrderedQuestionsEvent);
  }
  Future<void> _onGetOrderedQuestionsEvent(
    GetOrderedQuestionsEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Создаём копию списка, чтобы не мутировать state.questions
    final List<QuestionModel> questions = List.of(state.questions);

    // Если вопроса нет — вернём пустой список
    if (questions.isEmpty) {
      event.onSuccess(<QuestionModel>[]);
      return;
    }

    // Берём первые N вопросов (если questionCount <= 0 — вернём все)
    final int count =
        event.questionCount > 0 ? event.questionCount : questions.length;
    final List<QuestionModel> result =
        questions.take(count.clamp(0, questions.length)).toList();

    event.onSuccess(result);
  }

  Future<void> _onParseQuestionsEvent(
    ParseQuestionsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      // Берём готовый список из Dart
      final List<QuestionModel> questionsList = dartQuestions
          .map((e) => QuestionModel.fromJson(e).removeHtmlText())
          .toList();

      final List<QuestionModel> distractionQuestions =
          questionsList.where((e) => e.type?.contains("HARD") == true).toList();

      emit(state.copyWith(
        questions: List.of(questionsList),
        distractionQuestions: List.of(distractionQuestions),
        searchQuestions: List.from(questionsList),
        isLoading: false,
      ));

      add(GetBookmarksEvent());
      add(ParseTopicsEvent());
      add(GetTicketsStatisticsEvent());
    } catch (e) {
      emit(state.copyWith(
        questions: <QuestionModel>[],
        distractionQuestions: <QuestionModel>[],
        searchQuestions: <QuestionModel>[],
        isLoading: false,
      ));
    }
  }

  Future<void> _onParseTopicsEvent(
    ParseTopicsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Берём данные напрямую из Dart-списка
      List<TopicModel> topics =
          groupsGlobal.map((e) => TopicModel.fromJson(e)).toList();

      final List<TopicStatisticsEntity> topicsStatistics =
          await topicRepository.getTopicsStatistics();

      topics = topics.map((topic) {
        final localTopic = topicsStatistics.firstWhere(
          (element) => element.topicId == topic.id,
          orElse: () => TopicStatisticsEntity(topicId: topic.id),
        );
        return topic.copyWith(
          incorrectCount: localTopic.incorrectCount,
          correctCount: localTopic.correctCount,
          noAnswerCount: localTopic.noAnswerCount,
        );
      }).toList();

      emit(state.copyWith(topics: topics));
    } catch (e) {
      debugPrint('Error parsing topics: $e');
      emit(state.copyWith(topics: <TopicModel>[]));
    }
  }

  Future<void> _onBookmarkedEvent(
      BookmarkedEvent event, Emitter<HomeState> emit) async {
    event.isBookmarked
        ? await bookmarkRepository.removeBookmarked(event.questionId)
        : await bookmarkRepository.insertBookmarked(event.questionId);

    List<QuestionModel> updateBookmark(List<QuestionModel> questions) {
      return questions.map((question) {
        return question.id == event.questionId
            ? question.copyWith(isBookmarked: !question.isBookmarked)
            : question;
      }).toList();
    }

    final updatedQuestions = updateBookmark(state.questions);
    final updatedSearchQuestions = updateBookmark(state.searchQuestions);

    List<QuestionModel> updatedBookmarks;
    if (event.isBookmarked) {
      final indexOfBookmark =
          state.bookmarks.indexWhere((item) => item.id == event.questionId);
      if (indexOfBookmark != -1) {
        updatedBookmarks = List.from(state.bookmarks)
          ..removeAt(indexOfBookmark);
      } else {
        updatedBookmarks = List.from(state.bookmarks);
      }
    } else {
      final question = state.questions
          .firstWhere((question) => question.id == event.questionId)
          .copyWith(isBookmarked: true);
      updatedBookmarks = [
        question,
        ...state.bookmarks,
      ];
    }
    emit(state.copyWith(
      questions: updatedQuestions,
      searchQuestions: updatedSearchQuestions,
      bookmarks: updatedBookmarks,
    ));
  }

  Future<void> _onGetBookmarkEvent(
      GetBookmarksEvent event, Emitter<HomeState> emit) async {
    final List<BookmarkEntity> bookmarks =
        await bookmarkRepository.getBookmarks();

    final List<QuestionModel> bookmarkQuestions = bookmarks
        .map((bookmark) {
          final question = state.questions.firstWhere(
            (q) => q.id == bookmark.questionId,
            orElse: () => QuestionModel(),
          );
          return question.copyWith(isBookmarked: true);
        })
        .where((q) => q.id != -1) // remove empty/default questions
        .toList();

    List<QuestionModel> updatedQuestions = state.questions.map((question) {
      if (bookmarks.any((bookmark) => bookmark.questionId == question.id)) {
        return question.copyWith(isBookmarked: true);
      }
      return question;
    }).toList();

    List<QuestionModel> updatedSearchQuestions =
        state.searchQuestions.map((question) {
      if (bookmarks.any((bookmark) => bookmark.questionId == question.id)) {
        return question.copyWith(isBookmarked: true);
      }
      return question;
    }).toList();

    emit(state.copyWith(
        bookmarks: bookmarkQuestions,
        questions: updatedQuestions,
        searchQuestions: updatedSearchQuestions));
  }

  Future<void> _onDeleteBookmarksEvent(
      DeleteBookmarksEvent event, Emitter<HomeState> emit) async {
    await bookmarkRepository.deleteBookmarks();
    List<QuestionModel> updateQuestion(List<QuestionModel> questions) {
      return questions.map((question) {
        return question.copyWith(isBookmarked: false);
      }).toList();
    }

    emit(state.copyWith(
      bookmarks: [],
      questions: updateQuestion(state.questions),
      searchQuestions: updateQuestion(state.searchQuestions),
    ));
  }

  Future<void> _onSearchQuestionEvent(
      SearchQuestionEvent event, Emitter<HomeState> emit) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(searchQuestions: state.questions));
      return;
    }

    final String query = event.query.toLowerCase();
    final List<QuestionModel> filteredQuestions =
        state.questions.where((question) {
      return question.questionUz.toLowerCase().contains(query) ||
          question.questionRu.toLowerCase().contains(query) ||
          question.questionLa.toLowerCase().contains(query) ||
          question.answers.any((answer) {
            return answer.answerUz.toLowerCase().contains(query) ||
                answer.answerRu.toLowerCase().contains(query) ||
                answer.answerLa.toLowerCase().contains(query);
          });
    }).toList();

    emit(state.copyWith(searchQuestions: filteredQuestions));
  }

  Future<void> _onInitializeSearchEvent(
      InitializeSearchEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(searchQuestions: state.questions));
  }

  Future<void> _onGetTicketsStatisticsEvent(
    GetTicketsStatisticsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final List<TicketStatisticsEntity> tickets = state.questions
        .map((question) => question.groupId)
        .toSet()
        .toList()
        .map((e) => TicketStatisticsEntity(tickedId: e))
        .toList();

    final List<TicketStatisticsEntity> localTicketStatistics =
        await ticketRepository.getTicketsStatistics();
    final resultTickets = tickets.map((ticket) {
      final localTicket = localTicketStatistics.firstWhere(
        (element) => element.tickedId == ticket.tickedId,
        orElse: () => TicketStatisticsEntity(
          tickedId: ticket.tickedId,
        ),
      );
      return ticket.copyWith(
        correctCount: localTicket.correctCount,
        inCorrectCount: localTicket.inCorrectCount,
        noAnswerCount: localTicket.noAnswerCount,
      );
    }).toList();
    int count = 0;
    int totalCount = 0;
    for (var item in resultTickets) {
      count += item.correctCount > 0 ? item.correctCount : 0;
      totalCount += (item.noAnswerCount > 0 ? item.noAnswerCount : 0) +
          (item.correctCount > 0 ? item.correctCount : 0) +
          (item.inCorrectCount > 0 ? item.inCorrectCount : 0);
    }
    resultTickets.sort((a, b) => a.tickedId.compareTo(b.tickedId));
    if (count > state.questions.length) count = state.questions.length;
    emit(state.copyWith(
      ticketsStatistics: resultTickets,
      solveQuestionCount: count,
      totalCount: totalCount,
    ));
  }

  // HomeBloc — билеты
  Future<void> _onGetTicketQuestionEvent(
    GetTicketQuestionEvent event,
    Emitter<HomeState> emit,
  ) async {
    final bool isStaticMode = StorageRepository.getBool(
      StorageKeys.isStaticMode,
      defValue: true,
    );

    print('🎫 БИЛЕТ: Static Mode = $isStaticMode');

    List<QuestionModel> questions = state.questions
        .where((question) => question.groupId == event.ticketId)
        .toList();

    print('📝 Вопросов до: ${questions.map((q) => q.id).take(5).toList()}');

    if (isStaticMode) {
      // Статический режим — порядок сохраняем
      final random = Random();
      questions.shuffle(random);
      print('🔀 БИЛЕТ: перемешано');
    } else {
      questions.sort((a, b) => a.id.compareTo(b.id));
      print('✅ БИЛЕТ: порядок сохранён');
      // false → перемешиваем
    }

    print('📝 Вопросов после: ${questions.map((q) => q.id).take(5).toList()}');

    event.onSuccess(questions);
  }

  Future<void> _onGetTopicQuestionsEvent(
    GetTopicQuestionsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final bool isStaticMode = StorageRepository.getBool(
      StorageKeys.isStaticMode,
      defValue: true,
    );

    print('📚 TOPIC: Static Mode = $isStaticMode');

    // Берем все вопросы по теме
    List<QuestionModel> questions =
        state.questions.where((q) => q.groupId == event.topicId).toList();

    print('📝 Topic questions BEFORE: ${questions.map((q) => q.id).toList()}');

    final random = Random();

    if (isStaticMode) {
      // RANDOM если StaticMode = true
      questions = questions.map((q) {
        final answers = [...q.answers]..shuffle(random);
        return q.copyWith(answers: answers);
      }).toList()
        ..shuffle(random);

      print('🔀 Topic shuffled (random)');
    } else {
      // Сохраняем порядок, только перетасовываем ответы внутри вопросов
      questions = questions.map((q) {
        final answers = [...q.answers];
        return q.copyWith(answers: answers);
      }).toList();

      print('✅ TopicExam: StaticMode = false → порядок сохранён');
    }

    print('📝 Topic questions AFTER: ${questions.map((q) => q.id).toList()}');

    // Передаем в экран
    event.onSuccess(questions);
  }

  Future<void> _onGetTrainingQuestionsEvent(
      GetTrainingQuestionsEvent event, Emitter<HomeState> emit) async {
    final random = Random();
    final List<QuestionModel> questions = state.questions..shuffle(random);
    final List<QuestionModel> resultQuestions =
        questions.take(event.questionCount).toList();
    event.onSuccess(resultQuestions);
  }

  Future<void> _onGetDistractionQuestionsEvent(
      GetDistractionQuestionsEvent event, Emitter<HomeState> emit) async {
    final random = Random();
    final List<QuestionModel> questions = state.distractionQuestions
      ..shuffle(random);
    final List<QuestionModel> resultQuestions =
        questions.where((q) => q.type == 'HARD').toList();
    event.onSuccess(resultQuestions);
  }

  Future<void> _onGetRealExamQuestionsEvent(
      GetRealExamQuestionsEvent event, Emitter<HomeState> emit) async {
    final random = Random();
    final List<QuestionModel> questions = state.questions..shuffle(random);
    final List<QuestionModel> resultQuestions = questions.take(20).toList();
    event.onSuccess(resultQuestions);
  }

  Future<void> _onGetMarathonQuestionsEvent(
      GetMarathonQuestionsEvent event, Emitter<HomeState> emit) async {
    event.onSuccess(state.questions);
  }

  Future<void> _onDeleteTicketStatisticsEvent(
      DeleteTicketStatisticsEvent event, Emitter<HomeState> emit) async {
    await ticketRepository.deleteTicketStatistics();
    add(GetTicketsStatisticsEvent());
  }

  Future<void> _onDeleteTopicStatisticsEvent(
      DeleteTopicStatisticsEvent event, Emitter<HomeState> emit) async {
    await topicRepository.deleteTopicsStatistics();
    add(ParseTopicsEvent());
  }

  Future<void> _onGetMistakeHistoryEvent(
      GetMistakeHistoryEvent event, Emitter<HomeState> emit) async {
    final List<QuestionAttemptEntity> questionAttempts =
        await questionAttemptRepository.getAllQuestionAttempts();

    final List<MistakeQuestionEntity> mistakeQuestions = [];

    for (var attempt in questionAttempts) {
      final dateKey = extractDateKey(attempt.attemptedAt);
      final index =
          mistakeQuestions.indexWhere((element) => element.date == dateKey);

      if (index == -1) {
        mistakeQuestions.add(MistakeQuestionEntity(
          date: dateKey,
          attempts: [attempt],
        ));
      } else {
        final existingAttempts = mistakeQuestions[index].attempts;

        // Bu yerda shu kunga tegishli questionId oldin qo‘shilganmi yo‘qmi tekshiramiz
        final alreadyExists =
            existingAttempts.any((a) => a.questionId == attempt.questionId);
        if (!alreadyExists) {
          final updated = mistakeQuestions[index].copyWith(
            attempts: [...existingAttempts, attempt],
          );
          mistakeQuestions[index] = updated;
        }
      }
    }
    // Sana bo‘yicha kamayish tartibida saralash
    mistakeQuestions.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    emit(state.copyWith(mistakeQuestions: mistakeQuestions));
  }

  String extractDateKey(String dateString) {
    final date = DateTime.parse(dateString);
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _onDeleteMistakeHistoryEvent(
      DeleteMistakeHistoryEvent event, Emitter<HomeState> emit) async {
    await questionAttemptRepository.deleteAllQuestionAttempts();
    add(GetMistakeHistoryEvent());
  }

  Future<void> _onGetMistakeQuestionsEvent(
      GetMistakeQuestionsEvent event, Emitter<HomeState> emit) async {
    final attempts = event.attempts;
    List<QuestionModel> questions = [];
    for (var attempt in attempts) {
      for (var question in state.questions) {
        if (attempt.questionId == question.id) {
          questions.add(
            question.copyWith(
              errorAnswerIndex: event.isView ? attempt.errorAnswerIndex : -1,
              isAnswered: true && event.isView,
            ),
          );
        }
      }
    }

    event.onSuccess(questions);
  }

  Future<void> _onChangeAnswerFontSize(
      ChangeAnswerFontSize event, Emitter<HomeState> emit) async {
    await StorageRepository.putInt(
        StorageKeys.answerFontSize, event.answerFontSize);
    emit(state.copyWith(answerFontSize: event.answerFontSize));
  }

  Future<void> _onChangeQuestionFontSize(
      ChangeQuestionFontSize event, Emitter<HomeState> emit) async {
    await StorageRepository.putInt(
        StorageKeys.questionFontSize, event.questionFontSize);
    emit(state.copyWith(questionFontSize: event.questionFontSize));
  }

  Future<void> _onLoadFontSizeEvent(
      LoadFontSizeEvent event, Emitter<HomeState> emit) async {
    final questionFontSize =
        StorageRepository.getInt(StorageKeys.questionFontSize, defValue: 16);
    final answerFontSize =
        StorageRepository.getInt(StorageKeys.answerFontSize, defValue: 15);
    emit(state.copyWith(
        questionFontSize: questionFontSize, answerFontSize: answerFontSize));
  }
}

// Background thread'da ishlaydigan funksiyalar
Future<List<dynamic>> _decryptDataInBackground(
    Map<String, String> params) async {
  return await MyFunctions.decryptData(
    encryptedData: params['encryptedData']!,
    keyBase64: params['keyBase64']!,
    ivBase64: params['ivBase64']!,
  );
}
