import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  Future<void> getUser() async {
    log('📡 Firestore getUser called');

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc('345344')
        .get();

    if (doc.exists) {
      log(doc.data().toString());
    }
  }
}
