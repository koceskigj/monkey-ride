import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/notifications_provider.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = context.watch<NotificationsProvider>().hasUnread;
    final l10n = AppLocalizations.of(context)!;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.map_outlined),
          selectedIcon: const Icon(Icons.map),
          label: l10n.bottomNavMap,
        ),
        NavigationDestination(
          icon: _NotificationIcon(hasUnread: hasUnread),
          selectedIcon: _NotificationIcon(
            hasUnread: hasUnread,
            filled: true,
          ),
          label: l10n.bottomNavNotifications,
        ),
        NavigationDestination(
          icon: const Icon(Icons.info_outline),
          selectedIcon: const Icon(Icons.info),
          label: l10n.bottomNavInfo,
        ),
        NavigationDestination(
          icon: const Icon(Icons.location_on_outlined),
          selectedIcon: const Icon(Icons.location_on),
          label: l10n.bottomNavStops,
        ),
      ],
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final bool hasUnread;
  final bool filled;

  const _NotificationIcon({
    required this.hasUnread,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          filled
              ? Icons.notifications
              : Icons.notifications_outlined,
        ),
        if (hasUnread)
          const Positioned(
            right: -1,
            top: -1,
            child: SizedBox(
              width: 10,
              height: 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }
}