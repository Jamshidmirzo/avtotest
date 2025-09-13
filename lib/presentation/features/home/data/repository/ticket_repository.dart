import 'package:avtotest/presentation/features/home/data/entity/ticket_statistics_entity.dart';

abstract class TicketRepository {
  Future<List<TicketStatisticsEntity>> getTicketsStatistics();

  Future<void> insertTicketStatistics({
    required int ticketId,
    required int correctCount,
    required int incorrectCount,
    required int noAnswerCount,
  });

  Future<void> deleteTicketStatistics();
}
