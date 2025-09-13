class BookmarkEntity {
  final int questionId;
  final bool isBookmarked;

  BookmarkEntity({
    required this.questionId,
    this.isBookmarked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'question_id': questionId,
      'is_bookmarked': isBookmarked ? 1 : 0,
    };
  }

  factory BookmarkEntity.fromMap(Map<String, dynamic> map) {
    return BookmarkEntity(
      questionId: map['question_id'],
      isBookmarked: map['is_bookmarked'] == 1,
    );
  }
}
