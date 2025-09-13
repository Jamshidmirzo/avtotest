import 'package:avtotest/presentation/features/home/data/entity/topic_statistics_entity.dart';

abstract class TopicRepository {
  Future<List<TopicStatisticsEntity>> getTopicsStatistics();

  Future<void> insertTopicStatistic({
    required int topicId,
    required int correctCount,
    required int incorrectCount,
    required int noAnswerCount,
  });

  Future<void> deleteTopicsStatistics();
}
