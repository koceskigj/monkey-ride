import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../models/bus_line_model.dart';
import '../../models/location_model.dart';
import '../../providers/location_provider.dart';
import '../../providers/map_provider.dart';
import '../../providers/stops_provider.dart';
import 'stop_details_screen.dart';
import 'widgets/stop_row_card.dart';
import 'widgets/stops_direction_toggle.dart';
import 'widgets/stops_search_bar.dart';

class StopsScreen extends StatefulWidget {
  const StopsScreen({super.key});

  @override
  State<StopsScreen> createState() => _StopsScreenState();
}

class _StopsScreenState extends State<StopsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LocationModel> _stopsForDirection(
      MapProvider mapProvider,
      String direction,
      ) {
    final routeStopIds = mapProvider.lineRoutes
        .where((route) => route.direction == direction && route.isActive)
        .expand((route) => route.stopIdsOrdered)
        .toSet();

    return mapProvider.locations.where((location) {
      return location.type == 'bus_stop' && routeStopIds.contains(location.id);
    }).toList();
  }

  List<BusLineModel> _linesForStop(
      MapProvider mapProvider,
      String stopId,
      String direction,
      ) {
    final lineIds = mapProvider.lineRoutes
        .where(
          (route) =>
      route.direction == direction &&
          route.isActive &&
          route.stopIdsOrdered.contains(stopId),
    )
        .map((route) => route.lineId)
        .toSet();

    final lines = mapProvider.busLines
        .where((line) => lineIds.contains(line.id))
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    return lines;
  }

  List<LocationModel> _nearestStops(
      List<LocationModel> stops,
      Position position,
      ) {
    final sorted = [...stops];

    sorted.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        a.latitude,
        a.longitude,
      );
      final distanceB = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        b.latitude,
        b.longitude,
      );
      return distanceA.compareTo(distanceB);
    });

    return sorted.take(5).toList();
  }

  List<LocationModel> _searchStops(
      List<LocationModel> stops,
      String query,
      ) {
    final normalized = query.trim().toLowerCase();

    final filtered = stops.where((stop) {
      return stop.name.toLowerCase().contains(normalized);
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<MapProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final stopsProvider = context.watch<StopsProvider>();

    // Keep text field visually synced with provider state.
    if (_searchController.text != stopsProvider.searchQuery) {
      _searchController.value = TextEditingValue(
        text: stopsProvider.searchQuery,
        selection: TextSelection.collapsed(
          offset: stopsProvider.searchQuery.length,
        ),
      );
    }

    final direction = stopsProvider.selectedDirection;
    final allStopsForDirection = _stopsForDirection(mapProvider, direction);

    final bool hasSearch = stopsProvider.searchQuery.trim().isNotEmpty;

    List<LocationModel> visibleStops = [];

    if (hasSearch) {
      visibleStops = _searchStops(
        allStopsForDirection,
        stopsProvider.searchQuery,
      );
    } else if (locationProvider.currentPosition != null &&
        locationProvider.isGranted) {
      visibleStops = _nearestStops(
        allStopsForDirection,
        locationProvider.currentPosition!,
      );
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                StopsSearchBar(
                  controller: _searchController,
                  onChanged: stopsProvider.updateSearchQuery,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (!hasSearch && !locationProvider.isGranted) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_off_outlined,
                                  size: 72,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Enable location services in order to see the nearest bus stops.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: locationProvider.requestPermission,
                                  child: const Text('Enable location'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (visibleStops.isEmpty) {
                        return Center(
                          child: Text(
                            hasSearch
                                ? 'No stops found for your search.'
                                : 'No nearby stops available.',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: visibleStops.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final stop = visibleStops[index];
                          final lines = _linesForStop(
                            mapProvider,
                            stop.id,
                            direction,
                          );

                          return StopRowCard(
                            stop: stop,
                            lines: lines,
                            showNearby: !hasSearch,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => StopDetailsScreen(
                                    stop: stop,
                                    lines: lines,
                                    direction: direction,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        StopsDirectionToggle(
          selectedDirection: stopsProvider.selectedDirection,
          onDirectionSelected: stopsProvider.selectDirection,
        ),
      ],
    );
  }
}