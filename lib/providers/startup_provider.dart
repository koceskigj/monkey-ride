import 'package:flutter/material.dart';

import 'location_provider.dart';
import 'map_provider.dart';

class StartupProvider extends ChangeNotifier {
  bool _isReady = false;
  bool _isLoading = false;

  bool get isReady => _isReady;
  bool get isLoading => _isLoading;

  Future<void> initializeApp({
    required MapProvider mapProvider,
    required LocationProvider locationProvider,
  }) async {
    if (_isLoading || _isReady) return;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        mapProvider.loadMapData(),
        locationProvider.refreshLocationState(),
      ]);

      _isReady = true;
    } catch (_) {
      _isReady = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}