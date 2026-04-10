// import 'package:flutter/material.dart';
//
// import '../../../providers/location_provider.dart';
// import '../../../widgets/common/location_access_prompt.dart';
//
// class LocationPermissionBanner extends StatelessWidget {
//   final AppLocationPermissionState permissionState;
//   final VoidCallback onRequestPermission;
//   final VoidCallback onOpenSettings;
//   final VoidCallback onOpenLocationSettings;
//
//   const LocationPermissionBanner({
//     super.key,
//     required this.permissionState,
//     required this.onRequestPermission,
//     required this.onOpenSettings,
//     required this.onOpenLocationSettings,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return LocationAccessPrompt(
//       permissionState: permissionState,
//       onRequestPermission: onRequestPermission,
//       onOpenAppSettings: onOpenSettings,
//       onOpenLocationSettings: onOpenLocationSettings,
//       variant: LocationAccessPromptVariant.banner,
//     );
//   }
// }