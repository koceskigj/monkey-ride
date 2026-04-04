import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/info_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/stops_provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/top_branded_app_bar.dart';
import '../info/info_screen.dart';
import '../map/map_screen.dart';
import '../notifications/notifications_screen.dart';
import '../stops/stops_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    MapScreen(),
    NotificationsScreen(),
    InfoScreen(),
    StopsScreen(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = context.read<LocationProvider>();
      final notificationsProvider = context.read<NotificationsProvider>();
      final infoProvider = context.read<InfoProvider>();

      if (locationProvider.isGranted) {
        locationProvider.getCurrentLocation();
      }

      notificationsProvider.initialize();
      infoProvider.loadSlides();
    });
  }

  void _onTabSelected(int index) {
    final stopsProvider = context.read<StopsProvider>();

    if (_currentIndex == 3 && index != 3) {
      stopsProvider.reset();
    }

    if (index == 3) {
      stopsProvider.reset();
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: TopBrandedAppBar(),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}