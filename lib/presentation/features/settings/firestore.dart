import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  // Переменная для хранения подписки, чтобы её можно было закрыть
  StreamSubscription? _userSubscription;

  void startUserLogging(String userId, {VoidCallback? onDataChanged}) {
    log('🚀 Запуск постоянного наблюдения за пользователем: $userId');

    // Подписываемся на поток снимков (snapshots)
    _userSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        log('🔔 ОБНОВЛЕНИЕ ДАННЫХ [${DateTime.now().toIso8601String()}]:');
        log('   Premium: ${data?['has_premium']}');
        log('   Updated At: ${data?['updated_at']}');
        log('   Full Data: $data');
        onDataChanged?.call();
      } else {
        log('⚠️ Документ $userId не существует или был удален.');
      }
    }, onError: (error) {
      log('🔥 ОШИБКА СТРИМА: $error');
    });
  }

  Stream<DocumentSnapshot> getUserStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  void stopLogging() {
    _userSubscription?.cancel();
    log('🛑 Наблюдение остановлено.');
  }
}
