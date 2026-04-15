import 'package:flutter/material.dart';
import 'package:monkey_ride/l10n/app_localizations.dart';

import '../common/app_button.dart';

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

  String _resolveMessage(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;

    switch (key) {
      case 'errorNoInternet':
        return l10n.errorNoInternet;
      case 'errorServer':
        return l10n.errorServer;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageAssetPath != null)
              Image.asset(
                imageAssetPath!,
                height: size.height * 0.52,
                fit: BoxFit.contain,
              ),
            const SizedBox(height: 18),
            Text(
              _resolveMessage(context, message),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              AppButton(
                label: l10n.retry,
                icon: Icons.refresh,
                onPressed: onRetry!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}