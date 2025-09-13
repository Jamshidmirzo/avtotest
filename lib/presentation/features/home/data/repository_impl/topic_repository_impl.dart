import 'package:avtotest/data/datasource/database/database_helper.dart';
import 'package:avtotest/presentation/features/home/data/entity/topic_statistics_entity.dart';
import 'package:avtotest/presentation/features/home/data/repository/topic_repository.dart';

class TopicRepositoryImpl extends TopicRepository {
  final DatabaseHelper _databaseHelper;

  TopicRepositoryImpl(this._databaseHelper);

  @override
  Future<void> deleteTopicsStatistics() async {
    return await _databaseHelper.deleteTopicStatistics();
  }

  @override
  Future<List<TopicStatisticsEntity>> getTopicsStatistics() async {
    return await _databaseHelper.getTopicStatistics();
  }

  @override
  Future<void> insertTopicStatistic({
    required int topicId,
    required int correctCount,
    required int incorrectCount,
    required int noAnswerCount,
  }) async {
    return await _databaseHelper.insertTopicStatistics(
      topicId: topicId,
      correctCount: correctCount,
      incorrectCount: incorrectCount,
      noAnswerCount: noAnswerCount,
    );
  }
}
