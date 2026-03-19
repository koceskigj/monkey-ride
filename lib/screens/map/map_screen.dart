import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/map_provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<MapProvider>();
    final selectedRoute = mapProvider.selectedRoute;
    final selectedStops = mapProvider.selectedRouteStops;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: mapProvider.selectedLineId,
                isExpanded: true,
                items: mapProvider.busLines
                    .map(
                      (line) => DropdownMenuItem(
                    value: line.id,
                    child: Text(line.name),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    mapProvider.selectLine(value);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: mapProvider.selectedDirection,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                    value: 'west_to_east',
                    child: Text('West to East'),
                  ),
                  DropdownMenuItem(
                    value: 'east_to_west',
                    child: Text('East to West'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    mapProvider.selectDirection(value);
                  }
                },
              ),
              const SizedBox(height: 12),
              if (selectedRoute != null)
                Text(
                  '${selectedRoute.startLabel} → ${selectedRoute.endLabel}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Route Stops',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...selectedStops.map(
                    (stop) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(stop.name),
                    subtitle: Text(
                      '${stop.latitude}, ${stop.longitude}',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}