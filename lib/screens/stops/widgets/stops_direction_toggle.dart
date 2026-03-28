import 'package:flutter/material.dart';

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
    final isWestToEast = selectedDirection == 'west_to_east';

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => onDirectionSelected('west_to_east'),
                style: FilledButton.styleFrom(
                  backgroundColor: isWestToEast
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  foregroundColor: isWestToEast
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('West to East'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => onDirectionSelected('east_to_west'),
                style: FilledButton.styleFrom(
                  backgroundColor: !isWestToEast
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  foregroundColor: !isWestToEast
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.arrow_back),
                label: const Text('East to West'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}