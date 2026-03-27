import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/info_slide_model.dart';
import '../constants/firestore_paths.dart';

class InfoFirestoreService {
  final FirebaseFirestore _firestore;

  InfoFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<InfoSlideModel>> getInfoSlides() async {
    final snapshot = await _firestore
        .collection(FirestorePaths.infoSlides)
        .where('isActive', isEqualTo: true)
        .orderBy('orderIndex')
        .get();

    return snapshot.docs
        .map((doc) => InfoSlideModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}