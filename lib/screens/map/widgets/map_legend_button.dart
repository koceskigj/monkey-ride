import 'package:flutter/material.dart';
import 'package:monkey_ride/widgets/common/app_button.dart';

class MapLegendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapLegendButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      icon: Icons.info_outline,
      isIconOnly: true,
      onPressed: onPressed,
    );
  }
}