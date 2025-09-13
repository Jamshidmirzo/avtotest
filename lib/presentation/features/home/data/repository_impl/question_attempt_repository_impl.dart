import 'package:avtotest/data/datasource/database/database_helper.dart';
import 'package:avtotest/presentation/features/home/data/entity/question_attempt_entity.dart';
import 'package:avtotest/presentation/features/home/data/repository/question_attempt_repository.dart';

class QuestionAttemptRepositoryImpl extends QuestionAttemptRepository {
  final DatabaseHelper _databaseHelper;

  QuestionAttemptRepositoryImpl(this._databaseHelper);

  @override
  Future<void> addAllQuestionAttempts({required List<QuestionAttemptEntity> attempts}) async {
    return await _databaseHelper.insertAllQuestionAttempts(attempts);
  }

  @override
  Future<void> deleteAllQuestionAttempts() async {
    return await _databaseHelper.deleteAllQuestionAttempts();
  }

  @override
  Future<List<QuestionAttemptEntity>> getAllQuestionAttempts() async {
    return await _databaseHelper.getQuestionAttempts();
  }

  @override
  Future<void> removeQuestionsBYIdsAndDate({required List<int> questionIds, required String date}) async {
    return await _databaseHelper.removeQuestionsBYIdsAndDate(questionIds: questionIds, date: date);
  }
}
