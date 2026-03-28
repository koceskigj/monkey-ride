import 'package:flutter/material.dart';

import '../../../models/bus_line_model.dart';
import '../../../models/location_model.dart';
import 'nearby_badge.dart';

class StopRowCard extends StatelessWidget {
  final LocationModel stop;
  final List<BusLineModel> lines;
  final bool showNearby;
  final VoidCallback onTap;

  const StopRowCard({
    super.key,
    required this.stop,
    required this.lines,
    required this.showNearby,
    required this.onTap,
  });

  Color _hexToColor(String hex) {
    final cleanedHex = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleanedHex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                stop.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (showNearby) ...[
              const NearbyBadge(),
              const SizedBox(width: 10),
            ],
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: lines.map((line) {
                return Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _hexToColor(line.colorHex),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    line.number.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}