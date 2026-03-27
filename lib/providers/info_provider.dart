import 'package:flutter/material.dart';

import '../core/services/info_firestore_service.dart';
import '../models/info_slide_model.dart';

class InfoProvider extends ChangeNotifier {
  final InfoFirestoreService _service;

  InfoProvider({InfoFirestoreService? service})
      : _service = service ?? InfoFirestoreService();

  List<InfoSlideModel> _slides = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<InfoSlideModel> get slides => _slides;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadSlides() async {
    print('📘 [INFO] Starting to load info slides...');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedSlides = await _service.getInfoSlides();

      print('📘 [INFO] Firestore returned ${fetchedSlides.length} slides');

      for (final slide in fetchedSlides) {
        print('📘 [INFO] Slide:');
        print('   id: ${slide.id}');
        print('   title: ${slide.title}');
        print('   orderIndex: ${slide.orderIndex}');
        print('   isActive: ${slide.isActive}');
        print('   image: ${slide.imageAssetPath}');
      }

      if (fetchedSlides.isEmpty) {
        print('⚠️ [INFO] No slides found in Firestore.');
      }

      _slides = fetchedSlides;

      print('✅ [INFO] Info slides successfully loaded.');
    } catch (e, stackTrace) {
      print('❌ [INFO] Error loading info slides: $e');
      print(stackTrace);

      _errorMessage = 'Failed to load info slides.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}