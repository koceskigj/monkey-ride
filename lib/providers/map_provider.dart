import 'package:flutter/material.dart';

import '../core/services/map_firestore_service.dart';
import '../core/utils/app_error_messages.dart';
import '../models/bus_line_model.dart';
import '../models/line_route_model.dart';
import '../models/location_model.dart';

class MapProvider extends ChangeNotifier {
  final MapFirestoreService _mapFirestoreService;

  MapProvider({MapFirestoreService? mapFirestoreService})
      : _mapFirestoreService = mapFirestoreService ?? MapFirestoreService();

  List<BusLineModel> _busLines = [];
  List<LineRouteModel> _lineRoutes = [];
  List<LocationModel> _locations = [];

  final Set<String> _selectedLineIds = {};
  String _selectedDirection = 'west_to_east';

  bool _isLoading = false;
  String? _errorMessage;
  AppErrorType _errorType = AppErrorType.server;

  List<BusLineModel> get busLines => _busLines;
  List<LineRouteModel> get lineRoutes => _lineRoutes;
  List<LocationModel> get locations => _locations;
  Set<String> get selectedLineIds => _selectedLineIds;
  String get selectedDirection => _selectedDirection;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppErrorType get errorType => _errorType;

  bool get hasData =>
      _busLines.isNotEmpty && _lineRoutes.isNotEmpty && _locations.isNotEmpty;

  List<LineRouteModel> get selectedRoutes {
    return _lineRoutes.where((route) {
      return _selectedLineIds.contains(route.lineId) &&
          route.direction == _selectedDirection &&
          route.isActive;
    }).toList();
  }

  List<LocationModel> get selectedRouteStops {
    final allStopIds =
    selectedRoutes.expand((route) => route.stopIdsOrdered).toSet();

    return _locations.where((location) {
      return allStopIds.contains(location.id);
    }).toList();
  }

  Future<void> loadMapData() async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = AppErrorType.server;
    notifyListeners();

    try {
      final busLines = await _mapFirestoreService.getBusLines();
      final locations = await _mapFirestoreService.getLocations();
      final lineRoutes = await _mapFirestoreService.getLineRoutes();

      _busLines = busLines;
      _locations = locations;
      _lineRoutes = lineRoutes;

      _selectedLineIds
        ..clear()
        ..addAll(_busLines.map((line) => line.id));

      if (!hasData) {
        final errorInfo = AppErrorMessages.fromError(
          Exception('empty transport map data'),
          context: 'transport map',
        );
        _errorMessage = errorInfo.message;
        _errorType = errorInfo.type;
      }
    } catch (e) {
      _busLines = [];
      _locations = [];
      _lineRoutes = [];
      _selectedLineIds.clear();

      final errorInfo = AppErrorMessages.fromError(
        e,
        context: 'transport map',
      );
      _errorMessage = errorInfo.message;
      _errorType = errorInfo.type;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<int> getLineNumbersForStop(String stopId) {
    final lineIds = _lineRoutes
        .where(
          (route) =>
      route.stopIdsOrdered.contains(stopId) && route.isActive,
    )
        .map((route) => route.lineId)
        .toSet();

    final numbers = _busLines
        .where((line) => lineIds.contains(line.id))
        .map((line) => line.number)
        .toList();

    numbers.sort();
    return numbers;
  }

  String getShortDescription(String? description, {int maxLength = 30}) {
    if (description == null || description.trim().isEmpty) {
      return '';
    }

    final trimmed = description.trim();
    if (trimmed.length <= maxLength) {
      return trimmed;
    }

    return '${trimmed.substring(0, maxLength)}...';
  }

  void toggleLineSelection(String lineId) {
    if (_selectedLineIds.contains(lineId)) {
      if (_selectedLineIds.length > 1) {
        _selectedLineIds.remove(lineId);
      }
    } else {
      _selectedLineIds.add(lineId);
    }
    notifyListeners();
  }

  void selectDirection(String direction) {
    _selectedDirection = direction;
    notifyListeners();
  }
}