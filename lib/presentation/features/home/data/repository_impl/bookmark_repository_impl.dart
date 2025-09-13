import 'package:avtotest/data/datasource/database/database_helper.dart';
import 'package:avtotest/presentation/features/home/data/entity/bookmark_entity.dart';
import 'package:avtotest/presentation/features/home/data/repository/bookmark_repository.dart';

class BookmarkRepositoryImpl extends BookmarkRepository {
  final DatabaseHelper _databaseHelper;

  BookmarkRepositoryImpl(this._databaseHelper);

  @override
  Future<void> deleteBookmarks() async {
    return await _databaseHelper.deleteBookmarks();
  }

  @override
  Future<List<BookmarkEntity>> getBookmarks() async {
    return await _databaseHelper.getBookmarks();
  }

  @override
  Future<void> insertBookmarked(int questionId) async {
    await _databaseHelper.insertBookmarked(questionId: questionId);
    return;
  }

  @override
  Future<void> removeBookmarked(int questionId) async {
    // await _databaseHelper.deleteBookmarked(questionId: questionId);
  }
}
