import 'package:flutter/material.dart';

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? imageAssetPath;

  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.imageAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageAssetPath != null)
              Image.asset(
                imageAssetPath!,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.cloud_off,
                    size: 72,
                    color: colorScheme.outline,
                  );
                },
              )
            else
              Icon(
                Icons.cloud_off,
                size: 72,
                color: colorScheme.outline,
              ),
            const SizedBox(height: 18),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}