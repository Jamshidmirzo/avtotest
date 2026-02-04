import 'dart:async';

import 'package:avtotest/data/datasource/database/database_helper.dart';
import 'package:avtotest/data/datasource/storage/storage.dart';
import 'package:avtotest/presentation/features/home/data/repository/bookmark_repository.dart';
import 'package:avtotest/presentation/features/home/data/repository/question_attempt_repository.dart';
import 'package:avtotest/core/services/notification_service.dart';
import 'package:avtotest/presentation/features/home/data/repository/ticket_repository.dart';
import 'package:avtotest/presentation/features/home/data/repository/topic_repository.dart';
import 'package:avtotest/presentation/features/home/data/repository_impl/bookmark_repository_impl.dart';
import 'package:avtotest/presentation/features/home/data/repository_impl/question_attempt_repository_impl.dart';
import 'package:avtotest/presentation/features/home/data/repository_impl/ticket_repository_impl.dart';
import 'package:avtotest/presentation/features/home/data/repository_impl/topic_repository_impl.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.I;

Future<void> setupLocator({String? lang}) async {
  await StorageRepository.getInstance();
  
  // serviceLocator.registerLazySingleton<NotificationService>(() => NotificationService());

  serviceLocator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  serviceLocator
      .registerLazySingleton<BookmarkRepository>(() => BookmarkRepositoryImpl(serviceLocator<DatabaseHelper>()));
  serviceLocator.registerLazySingleton<QuestionAttemptRepository>(
      () => QuestionAttemptRepositoryImpl(serviceLocator<DatabaseHelper>()));
  serviceLocator.registerLazySingleton<TopicRepository>(() => TopicRepositoryImpl(serviceLocator<DatabaseHelper>()));
  serviceLocator.registerLazySingleton<TicketRepository>(() => TicketRepositoryImpl(serviceLocator<DatabaseHelper>()));
  // serviceLocator.registerLazySingleton(() => DioSettings());
}

Future resetLocator({String? lang}) async {
  await serviceLocator.reset();
  await setupLocator(lang: lang);
}
