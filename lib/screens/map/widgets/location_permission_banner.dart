import 'package:flutter/material.dart';

import '../../../providers/location_provider.dart';

class LocationPermissionBanner extends StatelessWidget {
  final LocationPermissionState permissionState;
  final VoidCallback onRequestPermission;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenLocationSettings;

  const LocationPermissionBanner({
    super.key,
    required this.permissionState,
    required this.onRequestPermission,
    required this.onOpenSettings,
    required this.onOpenLocationSettings,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String buttonText;
    VoidCallback action;

    switch (permissionState) {
      case LocationPermissionState.denied:
        title = 'Enable location to show your position and nearby stops.';
        buttonText = 'Enable location';
        action = onRequestPermission;
        break;
      case LocationPermissionState.permanentlyDenied:
        title = 'Location permission is permanently denied. Open app settings to enable it.';
        buttonText = 'Open settings';
        action = onOpenSettings;
        break;
      case LocationPermissionState.serviceDisabled:
        title = 'Location services are turned off. Enable them to use nearby features.';
        buttonText = 'Open location settings';
        action = onOpenLocationSettings;
        break;
      case LocationPermissionState.checking:
      case LocationPermissionState.granted:
        return const SizedBox.shrink();
    }

    return Positioned(
      left: 16,
      right: 16,
      top: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: action,
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}