import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.map_outlined),
          selectedIcon: Icon(Icons.map),
          label: 'Map',
        ),
        NavigationDestination(
          icon: _NotificationIcon(hasUnread: hasUnread),
          selectedIcon: _NotificationIcon(hasUnread: hasUnread, filled: true),
          label: 'Notifications',
        ),
        const NavigationDestination(
          icon: Icon(Icons.info_outline),
          selectedIcon: Icon(Icons.info),
          label: 'Info',
        ),
        const NavigationDestination(
          icon: Icon(Icons.location_on_outlined),
          selectedIcon: Icon(Icons.location_on),
          label: 'Stops',
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
        Icon(filled ? Icons.notifications : Icons.notifications_outlined),
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