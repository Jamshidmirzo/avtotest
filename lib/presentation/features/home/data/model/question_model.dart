import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/features/home/data/model/answer_model.dart';
import 'package:equatable/equatable.dart';

class QuestionModel extends Equatable {
  final String media;
  final String questionDescriptionLa;
  final String questionDescriptionUz;
  final String questionDescriptionRu;
  final String questionLa;
  final String questionUz;
  final String questionRu;
  final int groupId;
  final int lessonId;
  final String? type;
  final String? audioId;
  final int id;
  final List<AnswerModel> answers;
  final bool isBookmarked;
  final TestSolveStatus testSolveStatus;
  final bool isAnswered;
  final int errorAnswerIndex;
  final int confirmedAnswerIndex;

  bool get isNotAnswered => !isAnswered;

  bool get hasAudio => audioId != null && audioId!.isNotEmpty;

  const QuestionModel({
    this.media = "",
    this.questionDescriptionLa = "",
    this.questionDescriptionUz = "",
    this.questionDescriptionRu = "",
    this.questionLa = "",
    this.questionUz = "",
    this.questionRu = "",
    this.groupId = -1,
    this.lessonId = -1,
    this.type,
    this.audioId = "",
    this.id = -1,
    this.answers = const [],
    this.isBookmarked = false,
    this.isAnswered = false,
    this.errorAnswerIndex = -1,
    this.testSolveStatus = TestSolveStatus.notStarted,
    this.confirmedAnswerIndex = -1,
  });

  QuestionModel copyWith({
    String? media,
    String? questionDescriptionLa,
    String? questionDescriptionUz,
    String? questionDescriptionRu,
    String? questionLa,
    String? questionUz,
    String? questionRu,
    int? groupId,
    int? lessonId,
    String? type,
    String? audioId,
    int? id,
    List<AnswerModel>? answers,
    bool? isBookmarked,
    bool? isAnswered,
    int? errorAnswerIndex,
    TestSolveStatus? testSolveStatus,
    int? confirmedAnswerIndex,
  }) {
    return QuestionModel(
      media: media ?? this.media,
      questionDescriptionLa:
          questionDescriptionLa ?? this.questionDescriptionLa,
      questionDescriptionUz:
          questionDescriptionUz ?? this.questionDescriptionUz,
      questionDescriptionRu:
          questionDescriptionRu ?? this.questionDescriptionRu,
      questionLa: questionLa ?? this.questionLa,
      questionUz: questionUz ?? this.questionUz,
      questionRu: questionRu ?? this.questionRu,
      groupId: groupId ?? this.groupId,
      lessonId: lessonId ?? this.lessonId,
      type: type ?? this.type,
      audioId: audioId ?? this.audioId,
      id: id ?? this.id,
      answers: answers ?? this.answers,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isAnswered: isAnswered ?? this.isAnswered,
      errorAnswerIndex: errorAnswerIndex ?? this.errorAnswerIndex,
      testSolveStatus: testSolveStatus ?? this.testSolveStatus,
      confirmedAnswerIndex: confirmedAnswerIndex ?? this.confirmedAnswerIndex,
    );
  }

  QuestionModel removeHtmlText() {
    return QuestionModel(
      media: media,
      questionDescriptionLa: MyFunctions.removeHtmlTags(questionDescriptionLa),
      questionDescriptionUz: MyFunctions.removeHtmlTags(questionDescriptionUz),
      questionDescriptionRu: MyFunctions.removeHtmlTags(questionDescriptionRu),
      questionLa: MyFunctions.removeHtmlTags(questionLa),
      questionUz: MyFunctions.removeHtmlTags(questionUz),
      questionRu: MyFunctions.removeHtmlTags(questionRu),
      groupId: groupId,
      lessonId: lessonId,
      type: type,
      audioId: audioId,
      id: id,
      answers: answers,
      isBookmarked: isBookmarked,
      isAnswered: isAnswered,
      errorAnswerIndex: errorAnswerIndex,
      testSolveStatus: testSolveStatus,
      confirmedAnswerIndex: confirmedAnswerIndex,
    );
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      media: json['media'] ?? '',
      questionDescriptionLa: json['question_description_la'] ?? '',
      questionDescriptionUz: json['question_description_uz'] ?? '',
      questionDescriptionRu: json['question_description_ru'] ?? '',
      questionLa: json['question_la'] ?? '',
      questionUz: json['question_uz'] ?? '',
      questionRu: json['question_ru'] ?? '',
      groupId: json['group_id'] ?? 0,
      lessonId: json['lesson_id'] ?? 0,
      type: json['type'],
      audioId: json['audio_id'] ?? '',
      id: json['id'] ?? 0,
      answers: (json['answers'] as List<dynamic>)
          .map((answerJson) => AnswerModel.fromJson(answerJson))
          .toList(),
      errorAnswerIndex: -1,
      isAnswered: false,
      isBookmarked: false,
      testSolveStatus: TestSolveStatus.notStarted,
      confirmedAnswerIndex: -1,
    );
  }

  @override
  List<Object?> get props => [
        media,
        questionDescriptionLa,
        questionDescriptionUz,
        questionDescriptionRu,
        questionLa,
        questionUz,
        questionRu,
        groupId,
        lessonId,
        type,
        audioId,
        id,
        answers,
        isBookmarked,
        isAnswered,
        errorAnswerIndex,
        testSolveStatus,
        confirmedAnswerIndex,
      ];
}

enum TestSolveStatus { watched, correctSolved, incorrectSolved, notStarted }
