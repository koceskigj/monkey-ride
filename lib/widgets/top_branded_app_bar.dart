import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/localization/locale_provider.dart';
import '../app/theme/theme_provider.dart';

class TopBrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBrandedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final localeProvider = context.read<LocaleProvider>();

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.flag_outlined),
        onPressed: localeProvider.toggleLocale,
      ),
      title: const Text('Monkey Ride'),
      actions: [
        IconButton(
          icon: Icon(
            context.watch<ThemeProvider>().isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: themeProvider.toggleTheme,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}