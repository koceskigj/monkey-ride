import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum LocationPermissionState {
  checking,
  granted,
  denied,
  permanentlyDenied,
  serviceDisabled,
}

class LocationProvider extends ChangeNotifier {
  LocationPermissionState _permissionState = LocationPermissionState.checking;
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  LocationPermissionState get permissionState => _permissionState;
  Position? get currentPosition => _currentPosition;
  bool get isLoadingLocation => _isLoadingLocation;

  bool get isGranted => _permissionState == LocationPermissionState.granted;
  bool get isDenied => _permissionState == LocationPermissionState.denied;
  bool get isPermanentlyDenied =>
      _permissionState == LocationPermissionState.permanentlyDenied;
  bool get isServiceDisabled =>
      _permissionState == LocationPermissionState.serviceDisabled;

  Future<void> initialize() async {
    await checkPermissionStatus();
    if (isGranted) {
      await getCurrentLocation();
    }
  }

  Future<void> checkPermissionStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _permissionState = LocationPermissionState.serviceDisabled;
      notifyListeners();
      return;
    }

    final permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        _permissionState = LocationPermissionState.granted;
        break;
      case LocationPermission.denied:
        _permissionState = LocationPermissionState.denied;
        break;
      case LocationPermission.deniedForever:
        _permissionState = LocationPermissionState.permanentlyDenied;
        break;
      case LocationPermission.unableToDetermine:
        _permissionState = LocationPermissionState.denied;
        break;
    }

    notifyListeners();
  }

  Future<void> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _permissionState = LocationPermissionState.serviceDisabled;
      notifyListeners();
      return;
    }

    final permission = await Geolocator.requestPermission();

    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        _permissionState = LocationPermissionState.granted;
        notifyListeners();
        await getCurrentLocation();
        return;
      case LocationPermission.denied:
        _permissionState = LocationPermissionState.denied;
        break;
      case LocationPermission.deniedForever:
        _permissionState = LocationPermissionState.permanentlyDenied;
        break;
      case LocationPermission.unableToDetermine:
        _permissionState = LocationPermissionState.denied;
        break;
    }

    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    if (!isGranted) return;

    _isLoadingLocation = true;
    notifyListeners();

    try {
      final position = await Geolocator.getCurrentPosition();
      _currentPosition = position;
    } catch (_) {
      // keep current state, just fail silently for now
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  Future<void> openAppSettingsPage() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettingsPage() async {
    await Geolocator.openLocationSettings();
  }
}