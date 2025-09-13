import 'package:avtotest/data/datasource/database/database_helper.dart';
import 'package:avtotest/presentation/features/home/data/entity/ticket_statistics_entity.dart';
import 'package:avtotest/presentation/features/home/data/repository/ticket_repository.dart';

class TicketRepositoryImpl extends TicketRepository {
  final DatabaseHelper _databaseHelper;

  TicketRepositoryImpl(this._databaseHelper);

  @override
  Future<void> deleteTicketStatistics() async {
    return await _databaseHelper.deleteTicketStatistics();
  }

  @override
  Future<List<TicketStatisticsEntity>> getTicketsStatistics() async {
    return await _databaseHelper.getTicketStatistics();
  }

  @override
  Future<void> insertTicketStatistics({
    required int ticketId,
    required int correctCount,
    required int incorrectCount,
    required int noAnswerCount,
  }) async {
    return await _databaseHelper.insertTicketStatistics(
      ticketId: ticketId,
      correctCount: correctCount,
      incorrectCount: incorrectCount,
      noAnswerCount: noAnswerCount,
    );
  }
}
