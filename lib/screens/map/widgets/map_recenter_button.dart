import 'package:flutter/material.dart';

class MapRecenterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapRecenterButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.my_location),
        ),
      ),
    );
  }
}