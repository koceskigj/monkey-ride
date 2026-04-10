import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/stop_timetable_model.dart';
import '../constants/firestore_paths.dart';

class ArrivalsFirestoreService {
  final FirebaseFirestore _firestore;

  ArrivalsFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<StopTimetableModel>> getArrivalsForStop({
    required String stopId,
    required String direction,
  }) async {
    final snapshot = await _firestore
        .collection(FirestorePaths.arrivals)
        .where('stopId', isEqualTo: stopId)
        .where('direction', isEqualTo: direction)
        .where('isActive', isEqualTo: true)
        .get(const GetOptions(source: Source.server));

    return snapshot.docs
        .map((doc) => StopTimetableModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}