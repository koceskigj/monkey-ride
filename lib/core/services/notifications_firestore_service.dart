import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/app_notification_model.dart';
import '../constants/firestore_paths.dart';

class NotificationsFirestoreService {
  final FirebaseFirestore _firestore;

  NotificationsFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<AppNotificationModel>> getNotifications({int limit = 20}) async {
    final snapshot = await _firestore
        .collection(FirestorePaths.notifications)
        .where('isActive', isEqualTo: true)
        .orderBy('publishedAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => AppNotificationModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}