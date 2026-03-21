import 'package:flutter/material.dart';

import '../core/constants/sample_data.dart';
import '../models/bus_line_model.dart';
import '../models/line_route_model.dart';
import '../models/location_model.dart';

class MapProvider extends ChangeNotifier {
  final List<BusLineModel> _busLines = SampleData.busLines;
  final List<LineRouteModel> _lineRoutes = SampleData.lineRoutes;
  final List<LocationModel> _locations = SampleData.locations;

  final Set<String> _selectedLineIds = {
    'line_1',
    'line_2',
    'line_3',
    'line_4',
    'line_5',
  };

  String _selectedDirection = 'west_to_east';

  List<BusLineModel> get busLines => _busLines;
  List<LocationModel> get locations => _locations;
  Set<String> get selectedLineIds => _selectedLineIds;
  String get selectedDirection => _selectedDirection;

  List<LineRouteModel> get selectedRoutes {
    return _lineRoutes.where((route) {
      return _selectedLineIds.contains(route.lineId) &&
          route.direction == _selectedDirection &&
          route.isActive;
    }).toList();
  }

  List<LocationModel> get selectedRouteStops {
    final allStopIds = selectedRoutes
        .expand((route) => route.stopIdsOrdered)
        .toSet();

    return _locations.where((location) {
      return allStopIds.contains(location.id);
    }).toList();
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