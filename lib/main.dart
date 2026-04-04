import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/localization/locale_provider.dart';
import 'app/theme/theme_provider.dart';
import 'firebase_options.dart';
import 'providers/arrivals_provider.dart';
import 'providers/info_provider.dart';
import 'providers/location_provider.dart';
import 'providers/map_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/startup_provider.dart';
import 'providers/stops_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => InfoProvider()),
        ChangeNotifierProvider(create: (_) => StopsProvider()),
        ChangeNotifierProvider(create: (_) => StartupProvider()),
        ChangeNotifierProvider(create: (_) => ArrivalsProvider()),
      ],
      child: const MonkeyRideApp(),
    ),
  );
}