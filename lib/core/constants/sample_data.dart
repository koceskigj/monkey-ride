import '../../models/bus_line_model.dart';
import '../../models/line_route_model.dart';
import '../../models/location_model.dart';

class SampleData {
  static final List<BusLineModel> busLines = [
    const BusLineModel(
      id: 'line_1',
      number: 1,
      name: 'Line 1',
      colorHex: '#2E7D32',
      isActive: true,
    ),
    const BusLineModel(
      id: 'line_2',
      number: 2,
      name: 'Line 2',
      colorHex: '#1565C0',
      isActive: true,
    ),
    const BusLineModel(
      id: 'line_3',
      number: 3,
      name: 'Line 3',
      colorHex: '#E64A19',
      isActive: true,
    ),
    const BusLineModel(
      id: 'line_4',
      number: 4,
      name: 'Line 4',
      colorHex: '#C62828',
      isActive: true,
    ),
    const BusLineModel(
      id: 'line_5',
      number: 5,
      name: 'Line 5',
      colorHex: '#6A1B9A',
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
      stopIdsOrdered: ['stop_1_we', 'stop_2_we', 'stop_3_we'],
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
      id: 'route_2_we',
      lineId: 'line_2',
      direction: 'west_to_east',
      stopIdsOrdered: ['stop_1_we', 'stop_2_we'],
      polylinePoints: [
        {'latitude': 41.3450, 'longitude': 21.5550},
        {'latitude': 41.3465, 'longitude': 21.5600},
      ],
      startLabel: 'West Terminal',
      endLabel: 'North-East',
      isActive: true,
    ),
    const LineRouteModel(
      id: 'route_3_we',
      lineId: 'line_3',
      direction: 'west_to_east',
      stopIdsOrdered: ['stop_2_we', 'stop_3_we'],
      polylinePoints: [
        {'latitude': 41.3465, 'longitude': 21.5600},
        {'latitude': 41.3442, 'longitude': 21.5628},
      ],
      startLabel: 'Bus Station',
      endLabel: 'Center',
      isActive: true,
    ),
    const LineRouteModel(
      id: 'route_4_we',
      lineId: 'line_4',
      direction: 'west_to_east',
      stopIdsOrdered: ['stop_1_we', 'stop_3_we'],
      polylinePoints: [
        {'latitude': 41.3450, 'longitude': 21.5550},
        {'latitude': 41.3442, 'longitude': 21.5628},
      ],
      startLabel: 'West Side',
      endLabel: 'East Side',
      isActive: true,
    ),
    const LineRouteModel(
      id: 'route_5_we',
      lineId: 'line_5',
      direction: 'west_to_east',
      stopIdsOrdered: ['stop_3_we'],
      polylinePoints: [
        {'latitude': 41.3442, 'longitude': 21.5628},
      ],
      startLabel: 'Center',
      endLabel: 'Center',
      isActive: true,
    ),
    const LineRouteModel(
      id: 'route_1_ew',
      lineId: 'line_1',
      direction: 'east_to_west',
      stopIdsOrdered: ['stop_3_we', 'stop_2_we', 'stop_1_we'],
      polylinePoints: [
        {'latitude': 41.3442, 'longitude': 21.5628},
        {'latitude': 41.3465, 'longitude': 21.5600},
        {'latitude': 41.3450, 'longitude': 21.5550},
      ],
      startLabel: 'East Terminal',
      endLabel: 'West Terminal',
      isActive: true,
    ),
    const LineRouteModel(
      id: 'route_2_ew',
      lineId: 'line_2',
      direction: 'east_to_west',
      stopIdsOrdered: ['stop_2_we', 'stop_1_we'],
      polylinePoints: [
        {'latitude': 41.3465, 'longitude': 21.5600},
        {'latitude': 41.3450, 'longitude': 21.5550},
      ],
      startLabel: 'North-East',
      endLabel: 'West Terminal',
      isActive: true,
    ),
    const LineRouteModel(
      id: 'route_3_ew',
      lineId: 'line_3',
      direction: 'east_to_west',
      stopIdsOrdered: ['stop_3_we', 'stop_2_we'],
      polylinePoints: [
        {'latitude': 41.3442, 'longitude': 21.5628},
        {'latitude': 41.3465, 'longitude': 21.5600},
      ],
      startLabel: 'Center',
      endLabel: 'Bus Station',
      isActive: true,
    ),
    const LineRouteModel(
      id: 'route_4_ew',
      lineId: 'line_4',
      direction: 'east_to_west',
      stopIdsOrdered: ['stop_3_we', 'stop_1_we'],
      polylinePoints: [
        {'latitude': 41.3442, 'longitude': 21.5628},
        {'latitude': 41.3450, 'longitude': 21.5550},
      ],
      startLabel: 'East Side',
      endLabel: 'West Side',
      isActive: true,
    ),
    const LineRouteModel(
      id: 'route_5_ew',
      lineId: 'line_5',
      direction: 'east_to_west',
      stopIdsOrdered: ['stop_3_we'],
      polylinePoints: [
        {'latitude': 41.3442, 'longitude': 21.5628},
      ],
      startLabel: 'Center',
      endLabel: 'Center',
      isActive: true,
    ),
  ];
}