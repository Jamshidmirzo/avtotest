class TopicStatisticsEntity {
  final int topicId;
  final int correctCount;
  final int incorrectCount;
  final int noAnswerCount;

  const TopicStatisticsEntity({
    required this.topicId,
    this.correctCount = -1,
    this.incorrectCount = -1,
    this.noAnswerCount = -1,
  });

  Map<String, dynamic> toMap() {
    return {
      'topic_id': topicId,
      'correct_count': correctCount,
      'incorrect_count': incorrectCount,
      'no_answer_count': noAnswerCount,
    };
  }

  TopicStatisticsEntity copyWith({
    int? topicId,
    int? correctCount,
    int? incorrectCount,
    int? noAnswerCount,
  }) {
    return TopicStatisticsEntity(
      topicId: topicId ?? this.topicId,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      noAnswerCount: noAnswerCount ?? this.noAnswerCount,
    );
  }

  factory TopicStatisticsEntity.fromMap(Map<String, dynamic> map) {
    return TopicStatisticsEntity(
      topicId: map['topic_id'] ?? -1,
      correctCount: map['correct_count'] ?? -1,
      incorrectCount: map['incorrect_count'] ?? -1,
      noAnswerCount: map['no_answer_count'] ?? -1,
    );
  }
}
