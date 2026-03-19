import '../../models/bus_line_model.dart';
import '../../models/line_route_model.dart';
import '../../models/location_model.dart';

class SampleData {
  static final List<BusLineModel> busLines = [
    const BusLineModel(
      id: 'line_1',
      number: 1,
      name: 'Line 1',
      colorHex: '#E53935',
      isActive: true,
    ),
    const BusLineModel(
      id: 'line_2',
      number: 2,
      name: 'Line 2',
      colorHex: '#1E88E5',
      isActive: true,
    ),
    const BusLineModel(
      id: 'line_3',
      number: 3,
      name: 'Line 3',
      colorHex: '#43A047',
      isActive: true,
    ),
    const BusLineModel(
      id: 'line_4',
      number: 4,
      name: 'Line 4',
      colorHex: '#FB8C00',
      isActive: true,
    ),
  ];

  static final List<LocationModel> locations = [
    const LocationModel(
      id: 'stop_1_we',
      name: 'Tutunski Kombinat',
      type: 'bus_stop',
      latitude: 41.3450,
      longitude: 21.5550,
      description: 'West to East stop',
      isActive: true,
      searchKeywords: ['tutunski', 'kombinat'],
    ),
    const LocationModel(
      id: 'stop_2_we',
      name: 'Nova Autobuska',
      type: 'bus_stop',
      latitude: 41.3465,
      longitude: 21.5600,
      description: 'West to East stop',
      isActive: true,
      searchKeywords: ['nova', 'avtobuska', 'autobuska'],
    ),
    const LocationModel(
      id: 'stop_3_we',
      name: 'Centar',
      type: 'bus_stop',
      latitude: 41.3442,
      longitude: 21.5628,
      description: 'West to East stop',
      isActive: true,
      searchKeywords: ['centar', 'center'],
    ),
    const LocationModel(
      id: 'landmark_1',
      name: 'Clock Tower',
      type: 'landmark',
      latitude: 41.3457,
      longitude: 21.5548,
      description: 'Famous city landmark',
      isActive: true,
      searchKeywords: ['clock', 'tower', 'saat', 'kula'],
    ),
  ];

  static final List<LineRouteModel> lineRoutes = [
    const LineRouteModel(
      id: 'route_1_we',
      lineId: 'line_1',
      direction: 'west_to_east',
      stopIdsOrdered: [
        'stop_1_we',
        'stop_2_we',
        'stop_3_we',
      ],
      polylinePoints: [
        {'latitude': 41.3450, 'longitude': 21.5550},
        {'latitude': 41.3465, 'longitude': 21.5600},
        {'latitude': 41.3442, 'longitude': 21.5628},
      ],
      startLabel: 'West Terminal',
      endLabel: 'East Terminal',
      isActive: true,
    ),
    const LineRouteModel(
      id: 'route_1_ew',
      lineId: 'line_1',
      direction: 'east_to_west',
      stopIdsOrdered: [
        'stop_3_we',
        'stop_2_we',
        'stop_1_we',
      ],
      polylinePoints: [
        {'latitude': 41.3442, 'longitude': 21.5628},
        {'latitude': 41.3465, 'longitude': 21.5600},
        {'latitude': 41.3450, 'longitude': 21.5550},
      ],
      startLabel: 'East Terminal',
      endLabel: 'West Terminal',
      isActive: true,
    ),
  ];
}