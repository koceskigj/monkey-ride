import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_error_messages.dart';
import '../../models/bus_line_model.dart';
import '../../models/location_model.dart';
import '../../providers/location_provider.dart';
import '../../providers/map_provider.dart';
import '../../providers/stops_provider.dart';
import '../../widgets/common/app_error_state.dart';
import '../../widgets/common/location_access_prompt.dart';
import 'stop_arrivals_screen.dart';
import 'widgets/stop_row_card.dart';
import 'widgets/stops_direction_toggle.dart';
import 'widgets/stops_search_bar.dart';

class StopsScreen extends StatefulWidget {
  const StopsScreen({super.key});

  @override
  State<StopsScreen> createState() => _StopsScreenState();
}

class _StopsScreenState extends State<StopsScreen>
    with WidgetsBindingObserver {
  late final TextEditingController _searchController;

  bool _didInitialLocationCheck = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didInitialLocationCheck) {
      _didInitialLocationCheck = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        final locationProvider = context.read<LocationProvider>();
        await locationProvider.refreshLocationState();

        if (locationProvider.isEnabled &&
            locationProvider.currentPosition == null) {
          await locationProvider.getCurrentLocation();
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        final locationProvider = context.read<LocationProvider>();
        await locationProvider.refreshLocationState();

        if (locationProvider.isEnabled &&
            locationProvider.currentPosition == null) {
          await locationProvider.getCurrentLocation();
        }
      });
    }
  }

  Future<void> _handleEnableLocation(
      LocationProvider locationProvider,
      ) async {
    await locationProvider.openLocationAccessFlow();
    await locationProvider.refreshLocationState();

    if (locationProvider.isEnabled &&
        locationProvider.currentPosition == null) {
      await locationProvider.getCurrentLocation();
    }
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
      return location.type == 'bus_stop' &&
          routeStopIds.contains(location.id);
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

    final searchQuery = context.select<StopsProvider, String>(
          (p) => p.searchQuery,
    );

    final selectedDirection = context.select<StopsProvider, String>(
          (p) => p.selectedDirection,
    );

    final stopsProvider = context.read<StopsProvider>();

    if (searchQuery.isEmpty &&
        _searchController.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _searchController.clear();
      });
    }

    if (mapProvider.isLoading && !mapProvider.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mapProvider.errorMessage != null && !mapProvider.hasData) {
      return AppErrorState(
        message: mapProvider.errorMessage!,
        imageAssetPath:
        AppErrorMessages.imageForType(mapProvider.errorType),
        onRetry: mapProvider.loadMapData,
      );
    }

    final direction = selectedDirection;
    final allStopsForDirection =
    _stopsForDirection(mapProvider, direction);

    final hasSearch = searchQuery.trim().isNotEmpty;

    List<LocationModel> visibleStops = [];

    if (hasSearch) {
      visibleStops = _searchStops(
        allStopsForDirection,
        searchQuery,
      );
    } else if (locationProvider.currentPosition != null &&
        locationProvider.isEnabled) {
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
                      if (!hasSearch && !locationProvider.isEnabled) {
                        return LocationAccessPrompt(
                          onEnableLocation: () =>
                              _handleEnableLocation(locationProvider),
                          imageAssetPath:
                          'assets/images/error/mende_location_off.png',
                        );
                      }

                      if (!hasSearch &&
                          locationProvider.isEnabled &&
                          locationProvider.currentPosition == null &&
                          locationProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.separated(
                        itemCount: visibleStops.length,
                        separatorBuilder: (_, __) =>
                        const Divider(height: 1),
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
                                  builder: (_) =>
                                      StopArrivalsScreen(
                                        stop: stop,
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
          selectedDirection: selectedDirection,
          onDirectionSelected: stopsProvider.selectDirection,
        ),
      ],
    );
  }
}