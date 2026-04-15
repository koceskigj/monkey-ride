import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_button.dart';

class MapFiltersButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapFiltersButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: AppButton(
        label: l10n.filters,
        icon: Icons.tune,
        onPressed: onPressed,
      ),
    );
  }
}