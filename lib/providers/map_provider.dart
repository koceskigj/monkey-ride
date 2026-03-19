import 'package:flutter/material.dart';

import '../core/constants/sample_data.dart';
import '../models/bus_line_model.dart';
import '../models/line_route_model.dart';
import '../models/location_model.dart';

class MapProvider extends ChangeNotifier {
  final List<BusLineModel> _busLines = SampleData.busLines;
  final List<LineRouteModel> _lineRoutes = SampleData.lineRoutes;
  final List<LocationModel> _locations = SampleData.locations;

  String _selectedLineId = 'line_1';
  String _selectedDirection = 'west_to_east';

  List<BusLineModel> get busLines => _busLines;
  List<LocationModel> get locations => _locations;
  String get selectedLineId => _selectedLineId;
  String get selectedDirection => _selectedDirection;

  LineRouteModel? get selectedRoute {
    try {
      return _lineRoutes.firstWhere(
            (route) =>
        route.lineId == _selectedLineId &&
            route.direction == _selectedDirection &&
            route.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  List<LocationModel> get selectedRouteStops {
    final route = selectedRoute;
    if (route == null) return [];

    return route.stopIdsOrdered
        .map(
          (stopId) => _locations.firstWhere(
            (location) => location.id == stopId,
        orElse: () => const LocationModel(
          id: '',
          name: '',
          type: '',
          latitude: 0,
          longitude: 0,
          isActive: false,
          searchKeywords: [],
        ),
      ),
    )
        .where((location) => location.id.isNotEmpty)
        .toList();
  }

  void selectLine(String lineId) {
    _selectedLineId = lineId;
    notifyListeners();
  }

  void selectDirection(String direction) {
    _selectedDirection = direction;
    notifyListeners();
  }
}