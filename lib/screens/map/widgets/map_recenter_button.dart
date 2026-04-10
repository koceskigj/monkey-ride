import 'package:flutter/material.dart';
import 'package:monkey_ride/widgets/common/app_button.dart';

class MapRecenterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapRecenterButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      icon: Icons.my_location,
      isIconOnly: true,
      onPressed: onPressed,
    );
  }
}