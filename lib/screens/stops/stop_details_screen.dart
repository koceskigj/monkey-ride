import 'package:flutter/material.dart';

import '../../models/bus_line_model.dart';
import '../../models/location_model.dart';

class StopDetailsScreen extends StatelessWidget {
  final LocationModel stop;
  final List<BusLineModel> lines;
  final String direction;

  const StopDetailsScreen({
    super.key,
    required this.stop,
    required this.lines,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final directionLabel = direction == 'west_to_east'
        ? 'West to East'
        : 'East to West';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stop Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stop.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Direction: $directionLabel',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Lines at this stop',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: lines.map((line) {
                return Chip(
                  label: Text('Line ${line.number}'),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Arrivals and richer details will be added next.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}