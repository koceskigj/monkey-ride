import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/location_provider.dart';
import '../../providers/map_provider.dart';
import '../../providers/startup_provider.dart';
import '../home/home_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _didStart = false;
  bool _didNavigate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didStart) {
      _didStart = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startInitialization();
      });
    }
  }

  Future<void> _startInitialization() async {
    final startupProvider = context.read<StartupProvider>();
    final mapProvider = context.read<MapProvider>();
    final locationProvider = context.read<LocationProvider>();

    await startupProvider.initializeApp(
      mapProvider: mapProvider,
      locationProvider: locationProvider,
    );

    if (!mounted || _didNavigate) return;

    _didNavigate = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const HomeShell(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final startupProvider = context.watch<StartupProvider>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash/splash_background.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                color: Theme.of(context).colorScheme.surface,
              );
            },
          ),
          Container(
            color: Colors.black.withOpacity(0.12),
          ),
          SafeArea(
            child: Center(
              child: startupProvider.isLoading
                  ? SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}