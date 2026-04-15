import 'package:flutter/material.dart';
import 'package:monkey_ride/l10n/app_localizations.dart';


class NoBusesLeftState extends StatelessWidget {
  const NoBusesLeftState({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final imageHeight =
    (size.height * 0.52).clamp(300.0, 500.0).toDouble();

    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/error/mende_sleeping.png',
              height: imageHeight,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 18),
            Text(
              l10n.noBusesLeft,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}