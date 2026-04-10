import 'package:flutter/material.dart';

import '../core/services/info_firestore_service.dart';
import '../core/utils/app_error_messages.dart';
import '../models/info_slide_model.dart';

class InfoProvider extends ChangeNotifier {
  final InfoFirestoreService _service;

  InfoProvider({InfoFirestoreService? service})
      : _service = service ?? InfoFirestoreService();

  List<InfoSlideModel> _slides = [];
  bool _isLoading = false;
  String? _errorMessage;
  AppErrorType _errorType = AppErrorType.server;

  List<InfoSlideModel> get slides => _slides;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppErrorType get errorType => _errorType;

  bool get hasData => _slides.isNotEmpty;

  Future<void> loadSlides() async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = AppErrorType.server;
    notifyListeners();

    try {
      final fetchedSlides = await _service.getInfoSlides();
      _slides = fetchedSlides;
    } catch (e) {
      final errorInfo = AppErrorMessages.fromError(
        e,
        context: 'app info',
      );
      _errorMessage = errorInfo.message;
      _errorType = errorInfo.type;
      _slides = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}