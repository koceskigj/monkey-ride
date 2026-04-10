import 'package:flutter/material.dart';

import '../common/app_button.dart';

class LocationAccessPrompt extends StatelessWidget {
  final VoidCallback onEnableLocation;
  final String? imageAssetPath;
  final String message;

  const LocationAccessPrompt({
    super.key,
    required this.onEnableLocation,
    this.imageAssetPath,
    this.message = 'Send me a signal to generate nearest bus stops.',
  });

  @override
  Widget build(BuildContext context) {
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
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 18),
            AppButton(
              label: 'Enable location',
              icon: Icons.my_location,
              onPressed: onEnableLocation,
            ),
          ],
        ),
      ),
    );
  }
}