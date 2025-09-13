class QuestionAttemptEntity {
  final int questionId;
  final String status;
  final String attemptedAt;
  final String sourceType;
  final int sourceId;
  final int topicId;
  final int ticketId;
  final bool isSync;
  final bool isDelete;
  final int errorAnswerIndex;

  const QuestionAttemptEntity({
    this.questionId = -1,
    this.status = '',
    this.attemptedAt = '',
    this.sourceType = '',
    this.sourceId = -1,
    this.topicId = -1,
    this.ticketId = -1,
    this.isSync = false,
    this.isDelete = false,
    this.errorAnswerIndex = -1,
  });

  Map<String, dynamic> toMap() {
    return {
      'question_id': questionId,
      'status': status,
      'attempted_at': attemptedAt,
      'source_type': sourceType,
      'source_id': sourceId,
      'topic_id': topicId,
      'ticket_id': ticketId,
      'is_sync': isSync ? 1 : 0,
      'is_delete': isDelete ? 1 : 0,
      'error_answer_index': errorAnswerIndex,
    };
  }

  factory QuestionAttemptEntity.fromMap(Map<String, dynamic> map) {
    return QuestionAttemptEntity(
      questionId: map['question_id'] ?? -1,
      status: map['status'] ?? '',
      attemptedAt: map['attempted_at'] ?? '',
      sourceType: map['source_type'] ?? '',
      sourceId: map['source_id'] ?? -1,
      topicId: map['topic_id'] ?? -1,
      ticketId: map['ticket_id'] ?? -1,
      isSync: map['is_sync'] == 1,
      isDelete: map['is_delete'] == 1,
      errorAnswerIndex: map['error_answer_index'] ?? -1,
    );
  }
}
