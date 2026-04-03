import 'package:flutter/material.dart';

import '../../providers/location_provider.dart';

enum LocationAccessPromptVariant {
  banner,
  fullPage,
}

class LocationAccessPrompt extends StatelessWidget {
  final AppLocationPermissionState permissionState;
  final VoidCallback onRequestPermission;
  final VoidCallback onOpenAppSettings;
  final VoidCallback onOpenLocationSettings;
  final LocationAccessPromptVariant variant;
  final String? imageAssetPath;

  const LocationAccessPrompt({
    super.key,
    required this.permissionState,
    required this.onRequestPermission,
    required this.onOpenAppSettings,
    required this.onOpenLocationSettings,
    this.variant = LocationAccessPromptVariant.fullPage,
    this.imageAssetPath,
  });

  bool get _isGranted => permissionState == AppLocationPermissionState.granted;

  bool get _isPermanentlyDenied =>
      permissionState == AppLocationPermissionState.deniedForever;

  bool get _isServiceDisabled =>
      permissionState == AppLocationPermissionState.serviceDisabled;

  String get _message {
    if (_isServiceDisabled) {
      return 'Location services are turned off. Turn them on to use nearby bus stops.';
    }

    if (_isPermanentlyDenied) {
      return 'Location access is permanently denied. Open settings to enable it and use nearby bus stops.';
    }

    return 'Enable location services to use nearby bus stops.';
  }

  String get _buttonLabel {
    if (_isServiceDisabled) return 'Open location settings';
    if (_isPermanentlyDenied) return 'Open settings';
    return 'Enable location';
  }

  VoidCallback get _buttonAction {
    if (_isServiceDisabled) return onOpenLocationSettings;
    if (_isPermanentlyDenied) return onOpenAppSettings;
    return onRequestPermission;
  }

  @override
  Widget build(BuildContext context) {
    if (_isGranted) {
      return const SizedBox.shrink();
    }

    switch (variant) {
      case LocationAccessPromptVariant.banner:
        return _LocationAccessBanner(
          message: _message,
          buttonLabel: _buttonLabel,
          onPressed: _buttonAction,
        );
      case LocationAccessPromptVariant.fullPage:
        return _LocationAccessFullPage(
          message: _message,
          buttonLabel: _buttonLabel,
          onPressed: _buttonAction,
          imageAssetPath: imageAssetPath,
        );
    }
  }
}

class _LocationAccessBanner extends StatelessWidget {
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  const _LocationAccessBanner({
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.24 : 0.08,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.location_off_outlined),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: onPressed,
                child: Text(buttonLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationAccessFullPage extends StatelessWidget {
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;
  final String? imageAssetPath;

  const _LocationAccessFullPage({
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
    this.imageAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageAssetPath != null)
              Image.asset(
                imageAssetPath!,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.location_off_outlined,
                    size: 72,
                  );
                },
              )
            else
              const Icon(
                Icons.location_off_outlined,
                size: 72,
              ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}