import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/map_provider.dart';

class MapFiltersSheet extends StatelessWidget {
  const MapFiltersSheet({super.key});

  Color _hexToColor(String hex) {
    final cleanedHex = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleanedHex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<MapProvider>();
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.lines,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...mapProvider.busLines.map(
                  (line) => CheckboxListTile(
                value: mapProvider.selectedLineIds.contains(line.id),
                onChanged: (_) =>
                    mapProvider.toggleLineSelection(line.id),
                controlAffinity:
                ListTileControlAffinity.trailing,
                title: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: _hexToColor(line.colorHex),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.lineLabel(line.number)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.direction,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            RadioListTile<String>(
              value: 'west_to_east',
              groupValue: mapProvider.selectedDirection,
              onChanged: (value) {
                if (value != null) {
                  mapProvider.selectDirection(value);
                }
              },
              title: Text(l10n.westToEast),
            ),
            RadioListTile<String>(
              value: 'east_to_west',
              groupValue: mapProvider.selectedDirection,
              onChanged: (value) {
                if (value != null) {
                  mapProvider.selectDirection(value);
                }
              },
              title: Text(l10n.eastToWest),
            ),
          ],
        ),
      ),
    );
  }
}