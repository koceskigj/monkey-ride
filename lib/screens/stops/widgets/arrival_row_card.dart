import 'package:flutter/material.dart';

import '../../../models/bus_line_model.dart';

class ArrivalRowCard extends StatelessWidget {
  final BusLineModel line;
  final String arrivalText;
  final bool isSoon;

  const ArrivalRowCard({
    super.key,
    required this.line,
    required this.arrivalText,
    required this.isSoon,
  });

  Color _hexToColor(String hex) {
    final cleanedHex = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleanedHex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _hexToColor(line.colorHex),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    line.number.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  arrivalText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSoon ? Colors.red.shade400 : null,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.18),
          ),
        ],
      ),
    );
  }
}