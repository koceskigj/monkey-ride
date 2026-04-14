import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/localization/locale_provider.dart';
import '../app/theme/theme_provider.dart';

class TopBrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBrandedAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    final switchFlagPath = localeProvider.isEnglish
        ? 'assets/images/flags/flag_macedonia.png'
        : 'assets/images/flags/flag_england.png';

    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: null,
      leading: IconButton(
        onPressed: localeProvider.toggleLocale,
        icon: ClipOval(
          child: Image.asset(
            switchFlagPath,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return const Icon(Icons.flag_outlined);
            },
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            themeProvider.isDarkMode
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
          ),
          onPressed: themeProvider.toggleTheme,
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}