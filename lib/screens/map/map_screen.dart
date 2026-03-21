import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../app/theme/theme_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/map_provider.dart';
import 'widgets/location_permission_banner.dart';
import 'widgets/map_filters_button.dart';
import 'widgets/map_filters_sheet.dart';
import 'widgets/map_legend_button.dart';
import 'widgets/map_recenter_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  String? _darkMapStyle;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(41.3451, 21.5550),
    zoom: 13.8,
  );

  @override
  void initState() {
    super.initState();
    _loadDarkMapStyle();
  }

  Future<void> _loadDarkMapStyle() async {
    final style = await rootBundle.loadString(
      'assets/map_styles/dark_map_style.json',
    );
    setState(() {
      _darkMapStyle = style;
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

  void _showLegendDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Map Legend'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendRow(icon: Icons.pets, label: 'Bus stop'),
              SizedBox(height: 12),
              _LegendRow(icon: Icons.confirmation_num, label: 'Ticket office'),
              SizedBox(height: 12),
              _LegendRow(icon: Icons.account_balance, label: 'Attraction'),
              SizedBox(height: 12),
              _LegendRow(icon: Icons.local_cafe, label: 'Cafe'),
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

  Set<Marker> _buildStopMarkers(MapProvider mapProvider) {
    return mapProvider.selectedRouteStops.map((stop) {
      return Marker(
        markerId: MarkerId(stop.id),
        position: LatLng(stop.latitude, stop.longitude),
        infoWindow: InfoWindow(
          title: stop.name,
          snippet: 'Monkey stop',
        ),
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
          markers: _buildStopMarkers(mapProvider),
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
                onPressed: _showLegendDialog,
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

class _LegendRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LegendRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}