import 'package:avtotest/presentation/features/home/data/entity/bookmark_entity.dart';
import 'package:avtotest/presentation/features/home/data/entity/question_attempt_entity.dart';
import 'package:avtotest/presentation/features/home/data/entity/ticket_statistics_entity.dart';
import 'package:avtotest/presentation/features/home/data/entity/topic_statistics_entity.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'avtotest.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DatabaseTableName.bookmark} (
        question_id INTEGER PRIMARY KEY,
        is_bookmarked INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // status // -- correct / incorrect / skipped
    // source type ticket, topic,
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseTableName.questionAttempts} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        status TEXT NOT NULL,
        attempted_at TEXT NOT NULL,
        source_type TEXT NOT NULL,
        source_id INTEGER, 
        topic_id INTEGER NOT NULL, 
        ticket_id INTEGER NOT NULL,
        is_sync INTEGER NOT NULL, 
        is_delete INTEGER NOT NULL,
        error_answer_index INTEGER NOT NULL DEFAULT -1
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseTableName.ticketStatistics} (
        ticket_id INTEGER PRIMARY KEY,
        correct_count INTEGER NOT NULL DEFAULT 0,
        incorrect_count INTEGER NOT NULL DEFAULT 0,
        no_answer_count INTEGER NOT NULL DEFAULT 0,
        is_sync INTEGER NOT NULL, 
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseTableName.topicStatistics} (
        topic_id INTEGER PRIMARY KEY,
        correct_count INTEGER NOT NULL DEFAULT 0,
        incorrect_count INTEGER NOT NULL DEFAULT 0,
        no_answer_count INTEGER NOT NULL DEFAULT 0,
        is_sync INTEGER NOT NULL, 
        date TEXT NOT NULL
      )
    ''');
  }

  Future<List<BookmarkEntity>> getBookmarks() async {
    final db = await database;
    final result = await db.query(
      DatabaseTableName.bookmark,
      orderBy: 'created_at DESC',
    );
    return result.map((map) => BookmarkEntity.fromMap(map)).toList();
  }

  Future<int> insertBookmarked({required int questionId}) async {
    final db = await database;
    return await db.insert(
        DatabaseTableName.bookmark,
        {
          'question_id': questionId,
          "is_bookmarked": 1,
          'created_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteBookmarked({required int questionId}) async {
    final db = await database;
    return await db.delete(DatabaseTableName.bookmark, where: 'question_id = ?', whereArgs: [questionId]);
  }

  Future<void> deleteBookmarks() async {
    final db = await database;
    await db.delete(DatabaseTableName.bookmark);
  }

  Future<void> insertQuestionAttempt({
    required int questionId,
    required String status,
    required String attemptedAt,
    required String sourceType,
    required int sourceId,
    required int topicId,
    required int ticketId,
    required int isSync,
    required int isDelete,
  }) async {
    final db = await database;
    await db.insert(
      DatabaseTableName.questionAttempts,
      {
        'question_id': questionId,
        'status': status,
        'attempted_at': attemptedAt,
        'source_type': sourceType,
        'source_id': sourceId,
        'topic_id': topicId,
        'ticket_id': ticketId,
        'is_sync': isSync,
        'is_delete': isDelete
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertTicketStatistics({
    required int ticketId,
    required int correctCount,
    required int incorrectCount,
    required int noAnswerCount,
  }) async {
    final db = await database;
    await db.insert(
      DatabaseTableName.ticketStatistics,
      {
        'ticket_id': ticketId,
        'correct_count': correctCount,
        'incorrect_count': incorrectCount,
        'no_answer_count': noAnswerCount,
        'is_sync': 0, // Assuming is_sync is 0 for local storage
        'date': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TicketStatisticsEntity>> getTicketStatistics() async {
    final db = await database;
    final ticketStatistics = await db.query(DatabaseTableName.ticketStatistics);
    return ticketStatistics.map((ticket) => TicketStatisticsEntity.fromMap(ticket)).toList();
  }

  Future<void> deleteTicketStatistics() async {
    final db = await database;
    await db.delete(DatabaseTableName.ticketStatistics);
  }

  Future<void> insertTopicStatistics({
    required int topicId,
    required int correctCount,
    required int incorrectCount,
    required int noAnswerCount,
  }) async {
    final db = await database;
    await db.insert(
      DatabaseTableName.topicStatistics,
      {
        'topic_id': topicId,
        'correct_count': correctCount,
        'incorrect_count': incorrectCount,
        'no_answer_count': noAnswerCount,
        'is_sync': 0, // Assuming is_sync is 0 for local storage
        'date': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TopicStatisticsEntity>> getTopicStatistics() async {
    final db = await database;
    final ticketStatistics = await db.query(DatabaseTableName.topicStatistics);
    return ticketStatistics.map((topic) => TopicStatisticsEntity.fromMap(topic)).toList();
  }

  Future<void> deleteTopicStatistics() async {
    final db = await database;
    await db.delete(DatabaseTableName.topicStatistics);
  }

  Future<void> insertAllQuestionAttempts(List<QuestionAttemptEntity> attempts) async {
    final db = await database;
    for (var attempt in attempts) {
      await db.insert(
        DatabaseTableName.questionAttempts,
        attempt.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteAllQuestionAttempts() async {
    final db = await database;
    await db.delete(DatabaseTableName.questionAttempts);
    return;
  }

  Future<List<QuestionAttemptEntity>> getQuestionAttempts() async {
    final db = await database;
    final result = await db.query(
      DatabaseTableName.questionAttempts,
      where: 'status = ?',
      whereArgs: [TestSolveStatus.incorrectSolved.name],
    );
    return result.map((item) => QuestionAttemptEntity.fromMap(item)).toList();
  }

  Future<void> removeQuestionsBYIdsAndDate({
    required List<int> questionIds,
    required String date,
  }) async {
    if (questionIds.isEmpty) return; // Bo‘sh bo‘lsa, hech narsa qilinmaydi

    final db = await database;

    final questionPlaceholders = List.filled(questionIds.length, '?').join(','); // ?, ?, ?
    final whereClause = 'question_id IN ($questionPlaceholders) AND attempted_at LIKE ?';
    final whereArgs = [...questionIds, '$date%']; // Masalan: [12, 13, '2025-06-17%']

    await db.delete(
      DatabaseTableName.questionAttempts,
      where: whereClause,
      whereArgs: whereArgs,
    );
  }
}

class DatabaseTableName {
  static const String bookmark = 'bookmark';
  static const String questionAttempts = 'question_attempts';
  static const String ticketStatistics = 'ticket_statistics';
  static const String topicStatistics = 'topic_statistics';
}
