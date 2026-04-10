import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier with WidgetsBindingObserver {
  Position? _currentPosition;
  bool _isLoading = false;
  bool _isEnabled = false;

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  bool get isGranted => _isEnabled;
  bool get isEnabled => _isEnabled;

  Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(this);
    await refreshLocationState();
  }

  Future<void> refreshLocationState() async {
    _isLoading = true;
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();

      final hasPermission =
          permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse;

      _isEnabled = serviceEnabled && hasPermission;

      if (!_isEnabled) {
        _currentPosition = null;
      }
    } catch (_) {
      _isEnabled = false;
      _currentPosition = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openLocationAccessFlow() async {
    _isLoading = true;
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
      } else {
        final permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever ||
            permission == LocationPermission.unableToDetermine) {
          await Geolocator.openAppSettings();
        }
      }

      await refreshLocationState();

      if (_isEnabled && _currentPosition == null) {
        await getCurrentLocation();
      }
    } catch (_) {
      _isEnabled = false;
      _currentPosition = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    if (!_isEnabled) return;

    _isLoading = true;
    notifyListeners();

    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      _currentPosition = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openAppSettingsPage() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettingsPage() async {
    await Geolocator.openLocationSettings();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshLocationState();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}