import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum AppLocationPermissionState {
  loading,
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

class LocationProvider extends ChangeNotifier with WidgetsBindingObserver {
  Position? _currentPosition;
  bool _isLoading = false;
  AppLocationPermissionState _permissionState =
      AppLocationPermissionState.loading;

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  AppLocationPermissionState get permissionState => _permissionState;

  bool get isGranted => _permissionState == AppLocationPermissionState.granted;

  Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(this);
    await refreshLocationState();
  }

  Future<void> refreshLocationState() async {
    _isLoading = true;
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _permissionState = AppLocationPermissionState.serviceDisabled;
        _currentPosition = null;
        return;
      }

      final permission = await Geolocator.checkPermission();

      switch (permission) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          _permissionState = AppLocationPermissionState.granted;
          await getCurrentLocation();
          break;

        case LocationPermission.denied:
          _permissionState = AppLocationPermissionState.denied;
          _currentPosition = null;
          break;

        case LocationPermission.deniedForever:
          _permissionState = AppLocationPermissionState.deniedForever;
          _currentPosition = null;
          break;

        case LocationPermission.unableToDetermine:
          _permissionState = AppLocationPermissionState.denied;
          _currentPosition = null;
          break;
      }
    } catch (_) {
      _permissionState = AppLocationPermissionState.denied;
      _currentPosition = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> requestPermission() async {
    _isLoading = true;
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _permissionState = AppLocationPermissionState.serviceDisabled;
        _currentPosition = null;
        return;
      }

      final permission = await Geolocator.requestPermission();

      switch (permission) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          _permissionState = AppLocationPermissionState.granted;
          await getCurrentLocation();
          break;

        case LocationPermission.denied:
          _permissionState = AppLocationPermissionState.denied;
          _currentPosition = null;
          break;

        case LocationPermission.deniedForever:
          _permissionState = AppLocationPermissionState.deniedForever;
          _currentPosition = null;
          break;

        case LocationPermission.unableToDetermine:
          _permissionState = AppLocationPermissionState.denied;
          _currentPosition = null;
          break;
      }
    } catch (_) {
      _permissionState = AppLocationPermissionState.denied;
      _currentPosition = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    if (_permissionState != AppLocationPermissionState.granted) return;

    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      _currentPosition = null;
    }

    notifyListeners();
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