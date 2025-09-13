import 'package:avtotest/presentation/features/home/data/entity/question_attempt_entity.dart';

abstract class QuestionAttemptRepository {
  Future<void> addAllQuestionAttempts({required List<QuestionAttemptEntity> attempts});

  Future<void> deleteAllQuestionAttempts();

  Future<List<QuestionAttemptEntity>> getAllQuestionAttempts();

  Future<void> removeQuestionsBYIdsAndDate({required List<int> questionIds, required String date});
}
