import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/bus_line_model.dart';
import '../../models/line_route_model.dart';
import '../../models/location_model.dart';
import '../constants/firestore_paths.dart';

class MapFirestoreService {
  final FirebaseFirestore _firestore;

  MapFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<BusLineModel>> getBusLines() async {
    final snapshot = await _firestore
        .collection(FirestorePaths.busLines)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => BusLineModel.fromMap(doc.data(), doc.id))
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));
  }

  Future<List<LocationModel>> getLocations() async {
    final snapshot = await _firestore
        .collection(FirestorePaths.locations)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => LocationModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<LineRouteModel>> getLineRoutes() async {
    final snapshot = await _firestore
        .collection(FirestorePaths.lineRoutes)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => LineRouteModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}