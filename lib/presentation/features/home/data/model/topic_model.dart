class TopicModel {
  final int id;
  final String titleLa;
  final String titleUz;
  final String titleRu;
  final int order;
  final int correctCount;
  final int incorrectCount;
  final int noAnswerCount;

  const TopicModel({
    this.id = -1,
    this.titleLa = "",
    this.titleUz = "",
    this.titleRu = "",
    this.order = -1,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.noAnswerCount = 0,
  });

  TopicModel copyWith({
    int? id,
    String? titleLa,
    String? titleUz,
    String? titleRu,
    int? order,
    int? correctCount,
    int? incorrectCount,
    int? noAnswerCount,
  }) {
    return TopicModel(
      id: id ?? this.id,
      titleLa: titleLa ?? this.titleLa,
      titleUz: titleUz ?? this.titleUz,
      titleRu: titleRu ?? this.titleRu,
      order: order ?? this.order,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      noAnswerCount: noAnswerCount ?? this.noAnswerCount,
    );
  }

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] ?? -1,
      titleLa: json['title_la'] ?? '',
      titleUz: json['title_uz'] ?? '',
      titleRu: json['title_ru'] ?? '',
      order: json['order'] ?? -1,
      correctCount: json['correct_count'] ?? 0,
      incorrectCount: json['incorrect_count'] ?? 0,
      noAnswerCount: json['no_answer_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_la': titleLa,
      'title_uz': titleUz,
      'title_ru': titleRu,
      'order': order,
      'correct_count': correctCount,
      'incorrect_count': incorrectCount,
      'no_answer_count': noAnswerCount,
    };
  }
}
