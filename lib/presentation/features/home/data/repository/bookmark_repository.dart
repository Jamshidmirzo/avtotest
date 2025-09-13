import 'package:avtotest/presentation/features/home/data/entity/bookmark_entity.dart';

abstract class BookmarkRepository {
  Future<void> insertBookmarked(int questionId);

  Future<void> removeBookmarked(int questionId);

  Future<List<BookmarkEntity>> getBookmarks();

  Future<void> deleteBookmarks();
}
