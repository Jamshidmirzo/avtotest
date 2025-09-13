class TicketStatisticsEntity {
  final int tickedId;
  final int correctCount;
  final int inCorrectCount;
  final int noAnswerCount;

  const TicketStatisticsEntity({
    required this.tickedId,
    this.correctCount = -1,
    this.inCorrectCount = -1,
    this.noAnswerCount = -1,
  });

  Map<String, dynamic> toMap() {
    return {
      'ticket_id': tickedId,
      'correct_count': correctCount,
      'incorrect_count': inCorrectCount,
      'no_answer_count': noAnswerCount
    };
  }

  TicketStatisticsEntity copyWith({
    int? tickedId,
    int? correctCount,
    int? inCorrectCount,
    int? noAnswerCount,
  }) {
    return TicketStatisticsEntity(
        tickedId: tickedId ?? this.tickedId,
        correctCount: correctCount ?? this.correctCount,
        inCorrectCount: inCorrectCount ?? this.inCorrectCount,
        noAnswerCount: noAnswerCount ?? this.noAnswerCount);
  }

  factory TicketStatisticsEntity.fromMap(Map<String, dynamic> map) {
    return TicketStatisticsEntity(
      tickedId: map['ticket_id'] ?? -1,
      correctCount: map['correct_count'] ?? -1,
      inCorrectCount: map['incorrect_count'] ?? -1,
      noAnswerCount: map['no_answer_count'] ?? -1,
    );
  }
}
