import 'package:equatable/equatable.dart';

class AnswerModel extends Equatable {
  final String answerLa;
  final String answerUz;
  final String answerRu;
  final bool isCorrect;

  const AnswerModel({
    this.answerLa = "",
    this.answerUz = "",
    this.answerRu = "",
    this.isCorrect = false,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      answerLa: json['answer_la'] ?? '',
      answerUz: json['answer_uz'] ?? '',
      answerRu: json['answer_ru'] ?? '',
      isCorrect: json['is_correct'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        answerLa,
        answerUz,
        answerRu,
        isCorrect,
      ];
}
