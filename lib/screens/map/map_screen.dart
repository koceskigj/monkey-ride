import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../app/theme/theme_provider.dart';
import '../../core/utils/marker_icon_helper.dart';
import '../../models/location_model.dart';
import '../../providers/location_provider.dart';
import '../../providers/map_provider.dart';
import 'widgets/location_permission_banner.dart';
import 'widgets/map_filters_button.dart';
import 'widgets/map_filters_sheet.dart';
import 'widgets/map_legend_button.dart';
import 'widgets/map_recenter_button.dart';
import 'widgets/place_details_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  String? _darkMapStyle;

  BitmapDescriptor? _busStopMarkerLight;
  BitmapDescriptor? _busStopMarkerDark;
  BitmapDescriptor? _ticketOfficeMarker;
  BitmapDescriptor? _attractionMarker;
  BitmapDescriptor? _cafeMarker;

  bool _didLoadAssets = false;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(41.3451, 21.5550),
    zoom: 13.8,
  );

  @override
  void initState() {
    super.initState();
    _loadDarkMapStyle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didLoadAssets) {
      _didLoadAssets = true;
      _loadMarkerIcons();
    }
  }

  Future<void> _loadDarkMapStyle() async {
    final style = await rootBundle.loadString(
      'assets/map_styles/dark_map_style.json',
    );

    if (!mounted) return;

    setState(() {
      _darkMapStyle = style;
    });
  }

  Future<void> _loadMarkerIcons() async {
    final imageConfiguration = createLocalImageConfiguration(context);

    final busStopLight = await BitmapDescriptor.asset(
      imageConfiguration,
      'assets/icons/monkey_stop.png',
      width: 28,
      height: 28,
    );

    final busStopDark = await BitmapDescriptor.asset(
      imageConfiguration,
      'assets/icons/monkey_stop.png',
      width: 28,
      height: 28,
    );

    final ticketOffice = await MarkerIconHelper.fromIcon(
      icon: Icons.confirmation_num,
      color: Colors.blue,
      backgroundColor: Colors.white,
      size: 52,
    );

    final attraction = await MarkerIconHelper.fromIcon(
      icon: Icons.account_balance,
      color: Colors.purple,
      backgroundColor: Colors.white,
      size: 52,
    );

    final cafe = await MarkerIconHelper.fromIcon(
      icon: Icons.local_cafe,
      color: Colors.orange,
      backgroundColor: Colors.white,
      size: 52,
    );

    if (!mounted) return;

    setState(() {
      _busStopMarkerLight = busStopLight;
      _busStopMarkerDark = busStopDark;
      _ticketOfficeMarker = ticketOffice;
      _attractionMarker = attraction;
      _cafeMarker = cafe;
    });
  }

  Future<void> _applyMapStyle(bool isDarkMode) async {
    if (_mapController == null) return;

    if (isDarkMode) {
      await _mapController!.setMapStyle(_darkMapStyle);
    } else {
      await _mapController!.setMapStyle(null);
    }
  }

  Future<void> _recenterToUser(LocationProvider locationProvider) async {
    if (!locationProvider.isGranted) {
      await locationProvider.requestPermission();
      return;
    }

    if (locationProvider.currentPosition == null) {
      await locationProvider.getCurrentLocation();
    }

    final position = locationProvider.currentPosition;
    if (position == null || _mapController == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.5,
        ),
      ),
    );
  }

  void _showLegendDialog(bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Map Legend'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendImageRow(
                imagePath: isDarkMode
                    ? 'assets/icons/monkey_stop.png'
                    : 'assets/icons/monkey_stop.png',
                label: 'Bus stop',
              ),
              const SizedBox(height: 12),
              const _LegendIconRow(
                icon: Icons.confirmation_num,
                label: 'Ticket office',
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              const _LegendIconRow(
                icon: Icons.account_balance,
                label: 'Attraction',
                color: Colors.purple,
              ),
              const SizedBox(height: 12),
              const _LegendIconRow(
                icon: Icons.local_cafe,
                label: 'Cafe',
                color: Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFiltersSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: false,
      isScrollControlled: true,
      builder: (_) => const MapFiltersSheet(),
    );
  }

  void _showPlaceDetails(LocationModel location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (_) => PlaceDetailsSheet(location: location),
    );
  }

  Color _hexToColor(String hex) {
    final cleanedHex = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleanedHex', radix: 16));
  }

  Set<Polyline> _buildPolylines(MapProvider mapProvider) {
    return mapProvider.selectedRoutes.map((route) {
      final line = mapProvider.busLines.firstWhere(
            (line) => line.id == route.lineId,
      );

      return Polyline(
        polylineId: PolylineId(route.id),
        width: 5,
        color: _hexToColor(line.colorHex),
        points: route.polylinePoints
            .map(
              (point) => LatLng(
            point['latitude'] ?? 0,
            point['longitude'] ?? 0,
          ),
        )
            .toList(),
      );
    }).toSet();
  }

  BitmapDescriptor _markerIconForType(String type, bool isDarkMode) {
    switch (type) {
      case 'bus_stop':
        return isDarkMode
            ? (_busStopMarkerDark ?? BitmapDescriptor.defaultMarker)
            : (_busStopMarkerLight ?? BitmapDescriptor.defaultMarker);
      case 'ticket_office':
        return _ticketOfficeMarker ?? BitmapDescriptor.defaultMarker;
      case 'landmark':
        return _attractionMarker ?? BitmapDescriptor.defaultMarker;
      case 'cafe':
        return _cafeMarker ?? BitmapDescriptor.defaultMarker;
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  Set<Marker> _buildMarkers(MapProvider mapProvider, bool isDarkMode) {
    final visibleBusStops = mapProvider.selectedRouteStops;
    final otherLocations = mapProvider.locations
        .where((location) => location.type != 'bus_stop')
        .toList();

    final allVisibleLocations = [
      ...visibleBusStops,
      ...otherLocations,
    ];

    return allVisibleLocations.map((location) {
      final lineNumbers = mapProvider.getLineNumbersForStop(location.id);

      return Marker(
        markerId: MarkerId(location.id),
        position: LatLng(location.latitude, location.longitude),
        icon: _markerIconForType(location.type, isDarkMode),
        infoWindow: InfoWindow(
          title: location.name,
          snippet: location.type == 'bus_stop'
              ? 'Lines: ${lineNumbers.join(', ')}'
              : mapProvider.getShortDescription(location.description),
        ),
        onTap: () {
          if (location.type == 'landmark' || location.type == 'cafe') {
            _showPlaceDetails(location);
          }
        },
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final mapProvider = context.watch<MapProvider>();
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    unawaited(_applyMapStyle(isDarkMode));

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          myLocationEnabled: locationProvider.isGranted,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: false,
          polylines: _buildPolylines(mapProvider),
          markers: _buildMarkers(mapProvider, isDarkMode),
          onMapCreated: (controller) async {
            _mapController = controller;
            await _applyMapStyle(isDarkMode);
          },
        ),
        LocationPermissionBanner(
          permissionState: locationProvider.permissionState,
          onRequestPermission: locationProvider.requestPermission,
          onOpenSettings: locationProvider.openAppSettingsPage,
          onOpenLocationSettings: locationProvider.openLocationSettingsPage,
        ),
        Positioned(
          right: 16,
          top: MediaQuery.of(context).size.height * 0.34,
          child: Column(
            children: [
              MapRecenterButton(
                onPressed: () => _recenterToUser(locationProvider),
              ),
              const SizedBox(height: 12),
              MapLegendButton(
                onPressed: () => _showLegendDialog(isDarkMode),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 36,
          child: MapFiltersButton(
            onPressed: _showFiltersSheet,
          ),
        ),
      ],
    );
  }
}

class _LegendIconRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _LegendIconRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}

class _LegendImageRow extends StatelessWidget {
  final String imagePath;
  final String label;

  const _LegendImageRow({
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 22,
          height: 22,
        ),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}