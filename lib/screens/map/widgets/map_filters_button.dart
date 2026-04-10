import 'package:flutter/material.dart';

import '../../../widgets/common/app_button.dart';


class MapFiltersButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapFiltersButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppButton(
        label: 'Filters',
        icon: Icons.tune,
        onPressed: onPressed,
      ),
    );
  }
}