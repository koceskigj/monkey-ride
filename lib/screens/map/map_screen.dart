import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/location_provider.dart';
import 'widgets/location_permission_banner.dart';
import 'widgets/map_recenter_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(41.3451, 21.5550),
    zoom: 13.8,
  );

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

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          myLocationEnabled: locationProvider.isGranted,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: false,
          onMapCreated: (controller) {
            _mapController = controller;
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
          top: 90,
          child: MapRecenterButton(
            onPressed: () => _recenterToUser(locationProvider),
          ),
        ),
      ],
    );
  }
}