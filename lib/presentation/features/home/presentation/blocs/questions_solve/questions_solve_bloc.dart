import 'dart:async';
import 'dart:math';

import 'package:avtotest/data/datasource/di/service_locator.dart';
import 'package:avtotest/data/datasource/storage/storage.dart';
import 'package:avtotest/data/datasource/storage/storage_keys.dart';
import 'package:avtotest/presentation/features/home/data/entity/question_attempt_entity.dart';
import 'package:avtotest/presentation/features/home/data/model/answer_model.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/data/repository/question_attempt_repository.dart';
import 'package:avtotest/presentation/features/home/data/repository/ticket_repository.dart';
import 'package:avtotest/presentation/features/home/data/repository/topic_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'questions_solve_event.dart';
part 'questions_solve_state.dart';

class QuestionsSolveBloc
    extends Bloc<QuestionsSolveEvent, QuestionsSolveState> {
  final TopicRepository topicRepository = serviceLocator<TopicRepository>();
  final TicketRepository ticketRepository = serviceLocator<TicketRepository>();
  final QuestionAttemptRepository questionAttemptRepository =
      serviceLocator<QuestionAttemptRepository>();

  Timer? _timer;

  QuestionsSolveBloc() : super(QuestionsSolveState()) {
    on<InitialQuestionsEvent>(_onInitialQuestionsEvent);
    on<GetCorrectAnswerEvent>(_onGetCorrectAnswerEvent);
    on<BookmarkEvent>(_onBookmarkQuestionEvent);
    on<QuestionAnsweredEvent>(_onQuestionAnsweredEvent);
    on<MoveQuestionEvent>(_onMoveQuestionEvent);
    on<TimerTickEvent>(_onTimerTickEvent);
    on<StopTimerEvent>(_onStopTimerEvent);
    on<AnswerIsFullEvent>(_onAnswerIsFullEvent);
    on<InsertTicketStatisticsEvent>(_onInsertTicketStatisticsEvent);
    on<InsertTopicStatisticsEvent>(_onInsertTopicStatisticsEvent);
    on<RefreshMarathonEvent>(_onRefreshMarathonEvent);
    on<ShuffleModeEvent>(_onShuffleModeEvent);
    on<InsertQuestionAttemptsEvent>(_onInsertQuestionAttemptsEvent);
    on<RemoveStatisticsErrorEvent>(_onRemoveStatisticsErrorEvent);
    on<SetDateEvent>(_onSetDateEvent);
    on<InitQuestionsEvent>(_onInitQuestions);
    on<PauseAudioEvent>((event, emit) {});
    on<LoadQuestionsEvent>(_onLoadQuestionsEvent);

    on<ChangeQuestionIndexEvent>((event, emit) {
      emit(state.copyWith(currentIndex: event.newIndex));
    });
  }
  void _onInitQuestions(
    InitQuestionsEvent event,
    Emitter<QuestionsSolveState> emit,
  ) {
    emit(
      state.copyWith(
        questions: event.questions,
        currentIndex: 0,
      ),
    );
  }

  Future<void> _onLoadQuestionsEvent(
    LoadQuestionsEvent event,
    Emitter<QuestionsSolveState> emit,
  ) async {
    if (event.questions.isEmpty) {
      print("❌ Передан пустой список вопросов");
      emit(state.copyWith(questions: []));
      return;
    }

    print(
        "✅ Загружено ${event.questions.length} вопросов в QuestionsSolveBloc");

    emit(state.copyWith(
      questions: event.questions,
      currentIndex: 0,
    ));
  }

  Future<void> _onInitialQuestionsEvent(
    InitialQuestionsEvent event,
    Emitter<QuestionsSolveState> emit,
  ) async {
    _timer?.cancel();

    final bool isStaticMode = StorageRepository.getBool(
      StorageKeys.isStaticMode,
      defValue: true,
    );

    final bool isTicket = event.groupId != null && event.groupId != -1;
    final bool isTopic = event.lessonId != -1;
    final bool isMarathon = event.isMarathon;
    final random = Random();

    late List<QuestionModel> processedQuestions;

    if (isTicket) {
      // Билеты — учитываем static mode
      if (isStaticMode) {
        processedQuestions = event.questions
            .map((q) => q.copyWith(answers: [...q.answers]..shuffle(random)))
            .toList()
          ..shuffle(random);
        print('🔀 Билет: StaticMode = false → перемешано');
      } else {
        processedQuestions = List.of(event.questions);
        print('✅ Билет: StaticMode = true → порядок сохранён');
      }
    } else if (isTopic) {
      // TopicExam — учитываем static mode
      if (isStaticMode) {
        processedQuestions = event.questions
            .map((q) => q.copyWith(answers: [...q.answers]..shuffle(random)))
            .toList()
          ..shuffle(random);
        print('🔀 TopicExam: StaticMode = true → перемешано');
      } else {
        processedQuestions = List.of(event.questions);
        print('✅ TopicExam: StaticMode = false → порядок сохранён');
      }
    } else {
      // Все остальные экзамены
      if (isStaticMode) {
        processedQuestions = List.of(event.questions);
        print('✅ Exam: StaticMode = true → порядок сохранён');
      } else {
        processedQuestions = event.questions
            .map((q) => q.copyWith(answers: [...q.answers]..shuffle(random)))
            .toList()
          ..shuffle(random);
        print('🔀 Exam: StaticMode = false → перемешано');
      }
    }

    // Первый вопрос помечаем как просмотренный
    if (processedQuestions.isNotEmpty) {
      processedQuestions[0] = processedQuestions[0]
          .copyWith(testSolveStatus: TestSolveStatus.watched);
    }

    // Время для урока или марафона
    late Duration time;
    if (event.lessonId != -1) {
      time = event.questions.length > 100
          ? Duration(minutes: 90)
          : Duration(minutes: event.questions.length);
    } else {
      time = event.time;
    }

    // Эмитим состояние
    emit(
      state.copyWith(
        questions: processedQuestions,
        oldQuestions: event.questions,
        currentIndex: 0,
        time: time,
        totalTime: time,
        ticketId: event.groupId,
        topicId: event.lessonId,
      ),
    );

    // Таймер
    int secondsRemaining = state.time.inSeconds;
    if (secondsRemaining != 0) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (secondsRemaining > 0) {
          secondsRemaining--;
          add(TimerTickEvent());
        } else {
          add(TimerTickEvent());
          timer.cancel();
        }
      });
    }
  }

  Future<void> _onGetCorrectAnswerEvent(
    GetCorrectAnswerEvent event,
    Emitter<QuestionsSolveState> emit,
  ) async {
    print("Current index: ${state.currentIndex}");
    print("Questions length: ${state.questions.length}");

    if (state.questions.isEmpty) {
      print("❌ Questions are empty here");
      return;
    }

    final question = state.questions[state.currentIndex];
    final correctAnswer =
        question.answers.firstWhere((answer) => answer.isCorrect);
    print("✅ Correct answer: $correctAnswer");
    event.onSuccess(correctAnswer);
  }

  Future<void> _onBookmarkQuestionEvent(
      BookmarkEvent event, Emitter<QuestionsSolveState> emit) async {
    final question = event.question;
    final updatedQuestion =
        question.copyWith(isBookmarked: !question.isBookmarked);
    final questions = List<QuestionModel>.from(state.questions);
    final updateQuestions = questions.map((e) {
      if (e.id == question.id) {
        return updatedQuestion;
      }
      return e;
    }).toList();

    emit(state.copyWith(questions: updateQuestions));
  }

  Future<void> _onQuestionAnsweredEvent(
      QuestionAnsweredEvent event, Emitter<QuestionsSolveState> emit) async {
    final question = state.questions[state.currentIndex];

    final confirmation = StorageRepository.getBool(
        StorageKeys.isConfirmModeEnabled,
        defValue: false);
    final answer =
        state.questions[state.currentIndex].answers[event.answerIndex];
    final isCorrect = answer.isCorrect;

    QuestionModel updatedQuestion;

    if (confirmation) {
      final isAlreadyConfirmed =
          question.confirmedAnswerIndex == event.answerIndex;

      if (!isAlreadyConfirmed) {
        updatedQuestion = question.copyWith(
          confirmedAnswerIndex: event.answerIndex,
        );
      } else {
        updatedQuestion = question.copyWith(
          confirmedAnswerIndex: event.answerIndex,
          isAnswered: true,
          errorAnswerIndex: isCorrect ? -1 : event.answerIndex,
          testSolveStatus: isCorrect
              ? TestSolveStatus.correctSolved
              : TestSolveStatus.incorrectSolved,
        );
      }
    } else {
      updatedQuestion = question.copyWith(
        isAnswered: true,
        errorAnswerIndex: isCorrect ? -1 : event.answerIndex,
        testSolveStatus: isCorrect
            ? TestSolveStatus.correctSolved
            : TestSolveStatus.incorrectSolved,
      );
    }

    final questions = List<QuestionModel>.from(state.questions);
    for (var item in questions) {
      item.copyWith(confirmedAnswerIndex: -1);
    }
    questions[state.currentIndex] = updatedQuestion;
    emit(state.copyWith(questions: questions));

    if (event.isMarathon) {
      StorageRepository.putInt(StorageKeys.lastMarathonQuestionId, question.id);
    }
    if ((state.questions[state.currentIndex].isAnswered)) {
      event.onSuccess(!state
          .questions[state.currentIndex].answers[event.answerIndex].isCorrect);
    }

    if (StorageRepository.getBool(StorageKeys.isNextMode, defValue: true)) {
      if (state.currentIndex < state.questions.length - 1 &&
          state.questions[state.currentIndex].isAnswered) {
        //add(MoveQuestionEvent(index: state.currentIndex + 1));
        event.onNext();
      }
    }
  }

  Future<void> _onMoveQuestionEvent(
      MoveQuestionEvent event, Emitter<QuestionsSolveState> emit) async {
    // final isShuffle = StorageRepository.getBool(StorageKeys.isShuffleMode, defValue: false);
    final isShuffle = true;
    if (isShuffle) {
      add(ShuffleModeEvent(index: state.currentIndex));
    }
    final List<QuestionModel> questions = List.from(state.questions);
    if (questions[event.index].testSolveStatus == TestSolveStatus.notStarted) {
      questions[event.index] = questions[event.index].copyWith(
        testSolveStatus: TestSolveStatus.watched,
      );
    }
    List<QuestionModel> newQuestions = questions.map((question) {
      return question.copyWith(
        confirmedAnswerIndex: -1,
      );
    }).toList();
    emit(state.copyWith(currentIndex: event.index, questions: newQuestions));
  }

  Future<void> _onTimerTickEvent(
      TimerTickEvent event, Emitter<QuestionsSolveState> emit) async {
    final secondsRemaining = state.time.inSeconds - 1;
    if (secondsRemaining >= 0) {
      emit(state.copyWith(time: Duration(seconds: secondsRemaining)));
    }
  }

  Future<void> _onStopTimerEvent(
      StopTimerEvent event, Emitter<QuestionsSolveState> emit) async {
    _timer?.cancel();
    event.onStop();
  }

  Future<void> _onAnswerIsFullEvent(
      AnswerIsFullEvent event, Emitter<QuestionsSolveState> emit) async {
    final isAnswered =
        state.questions.where((question) => question.isAnswered).length ==
            state.questions.length;
    event.onSuccess(isAnswered);
  }

  Future<void> _onInsertTicketStatisticsEvent(InsertTicketStatisticsEvent event,
      Emitter<QuestionsSolveState> emit) async {
    if (state.ticketId != -1) {
      await ticketRepository.insertTicketStatistics(
        ticketId: state.ticketId,
        correctCount: state.questions
            .where((question) =>
                question.testSolveStatus == TestSolveStatus.correctSolved)
            .length,
        incorrectCount: state.questions
            .where((question) =>
                question.testSolveStatus == TestSolveStatus.incorrectSolved)
            .length,
        noAnswerCount: state.questions
            .where(
              (question) =>
                  question.testSolveStatus == TestSolveStatus.watched ||
                  question.testSolveStatus == TestSolveStatus.notStarted,
            )
            .length,
      );
    }
  }

  Future<void> _onInsertTopicStatisticsEvent(InsertTopicStatisticsEvent event,
      Emitter<QuestionsSolveState> emit) async {
    if (state.topicId != -1) {
      await topicRepository.insertTopicStatistic(
        topicId: state.topicId,
        correctCount: state.questions
            .where((question) =>
                question.testSolveStatus == TestSolveStatus.correctSolved)
            .length,
        incorrectCount: state.questions
            .where((question) =>
                question.testSolveStatus == TestSolveStatus.incorrectSolved)
            .length,
        noAnswerCount: state.questions
            .where(
              (question) =>
                  question.testSolveStatus == TestSolveStatus.watched ||
                  question.testSolveStatus == TestSolveStatus.notStarted,
            )
            .length,
      );
    }
  }

  Future<void> _onRefreshMarathonEvent(
      RefreshMarathonEvent event, Emitter<QuestionsSolveState> emit) async {
    StorageRepository.putInt(
      StorageKeys.lastMarathonQuestionId,
      -1,
    );
    emit(state.copyWith(
      questions: state.oldQuestions,
    ));
  }

  Future<void> _onShuffleModeEvent(
      ShuffleModeEvent event, Emitter<QuestionsSolveState> emit) async {
    final random = Random();
    final shuffledQuestions = state.questions.map((e) {
      if (event.index == state.questions.indexOf(e)) {
        late List<AnswerModel> answers;
        if (!e.isAnswered) {
          answers = shuffleAnswers(List<AnswerModel>.from(e.answers), random);
        } else {
          answers = e.answers;
        }
        return e.copyWith(answers: answers);
      } else {
        return e;
      }
    }).toList();
    emit(state.copyWith(questions: shuffledQuestions));
  }

  List<AnswerModel> shuffleAnswers(List<AnswerModel> original, Random random) {
    if (original.length <= 1) return List<AnswerModel>.from(original);

    List<AnswerModel> shuffled;
    int attempts = 0;

    do {
      shuffled = List<AnswerModel>.from(original)..shuffle(random);
      attempts++;
    } while (listEquals(shuffled, original) && attempts < 5);

    return shuffled;
  }

  Future<void> _onInsertQuestionAttemptsEvent(InsertQuestionAttemptsEvent event,
      Emitter<QuestionsSolveState> emit) async {
    final attempts = state.questions
        .where((question) =>
            question.testSolveStatus != TestSolveStatus.notStarted)
        .map((question) {
      int mainIndex = -1;
      if (question.errorAnswerIndex != -1) {
        mainIndex = state.oldQuestions
            .firstWhere((e) => e.id == question.id)
            .answers
            .indexWhere((answer) {
          return answer.answerLa ==
              question.answers[question.errorAnswerIndex].answerLa;
        });
      }

      return QuestionAttemptEntity(
        questionId: question.id,
        status: question.testSolveStatus.name,
        attemptedAt: DateTime.now().toIso8601String(),
        sourceType: state.ticketId != -1
            ? 'ticket'
            : state.topicId != -1
                ? 'topic'
                : "other",
        sourceId: state.ticketId != -1
            ? state.ticketId
            : state.topicId != -1
                ? state.topicId
                : -1,
        topicId: state.topicId,
        ticketId: state.ticketId,
        isSync: false,
        isDelete: false,
        errorAnswerIndex: mainIndex,
      );
    }).toList();
    await questionAttemptRepository.addAllQuestionAttempts(attempts: attempts);
  }

  Future<void> _onRemoveStatisticsErrorEvent(RemoveStatisticsErrorEvent event,
      Emitter<QuestionsSolveState> emit) async {
    final questions = List<QuestionModel>.from(state.questions);
    final questionIds = questions
        .where((question) =>
            question.testSolveStatus == TestSolveStatus.correctSolved)
        .map((item) => item.id)
        .toList();
    await questionAttemptRepository.removeQuestionsBYIdsAndDate(
        questionIds: questionIds, date: state.date);
  }

  Future<void> _onSetDateEvent(
      SetDateEvent event, Emitter<QuestionsSolveState> emit) async {
    emit(state.copyWith(date: event.date));
  }
}
