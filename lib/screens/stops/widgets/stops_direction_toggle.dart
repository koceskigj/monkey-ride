import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class StopsDirectionToggle extends StatelessWidget {
  final String selectedDirection;
  final ValueChanged<String> onDirectionSelected;

  const StopsDirectionToggle({
    super.key,
    required this.selectedDirection,
    required this.onDirectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWestToEast = selectedDirection == 'west_to_east';
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () => onDirectionSelected('west_to_east'),
                style: FilledButton.styleFrom(
                  backgroundColor: isWestToEast
                      ? colorScheme.primary
                      : colorScheme.surface,
                  foregroundColor: isWestToEast
                      ? colorScheme.onPrimary
                      : colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.westToEast,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => onDirectionSelected('east_to_west'),
                style: FilledButton.styleFrom(
                  backgroundColor: !isWestToEast
                      ? colorScheme.primary
                      : colorScheme.surface,
                  foregroundColor: !isWestToEast
                      ? colorScheme.onPrimary
                      : colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        l10n.eastToWest,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}