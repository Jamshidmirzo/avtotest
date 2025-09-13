// class MistakeEntity {
//   final int questionId;
//   final bool isCorrect;
//   final int answerIndex;
//   final int groupId;
//   final int lessonId;
//   final String solveDate;
//
//   MistakeEntity({
//     required this.questionId,
//     required this.answerIndex,
//     this.isCorrect = true,
//     required this.groupId,
//     required this.lessonId,
//     required this.solveDate,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'questionId': questionId,
//       'isCorrect': isCorrect ? 1 : 0,
//       'answerIndex': answerIndex,
//       'groupId': groupId,
//       'lessonId': lessonId,
//       'solveDate': solveDate,
//     };
//   }
//
//   factory MistakeEntity.fromMap(Map<String, dynamic> map) {
//     return MistakeEntity(
//       questionId: map['questionId'],
//       isCorrect: map['isCorrect'] == 1,
//       answerIndex: map['answerIndex'],
//       groupId: map['groupId'],
//       lessonId: map['lessonId'],
//       solveDate: map['solveDate'] ?? "",
//     );
//   }
// }
