import 'package:flutter/material.dart';
import 'package:monkey_ride/l10n/app_localizations.dart';


import '../common/app_button.dart';

class LocationAccessPrompt extends StatelessWidget {
  final VoidCallback onEnableLocation;
  final String? imageAssetPath;

  const LocationAccessPrompt({
    super.key,
    required this.onEnableLocation,
    this.imageAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight =
    (screenHeight * 0.42).clamp(160.0, 320.0).toDouble();

    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageAssetPath != null)
              Image.asset(
                imageAssetPath!,
                height: imageHeight,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.location_off_outlined,
                    size: 72,
                    color: colorScheme.outline,
                  );
                },
              )
            else
              Icon(
                Icons.location_off_outlined,
                size: 72,
                color: colorScheme.outline,
              ),
            const SizedBox(height: 18),
            Text(
              l10n.locationMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 18),
            AppButton(
              label: l10n.enableLocation,
              icon: Icons.my_location,
              onPressed: onEnableLocation,
            ),
          ],
        ),
      ),
    );
  }
}