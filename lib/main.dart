import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:monkey_ride/providers/location_provider.dart';
import 'package:monkey_ride/providers/map_provider.dart';
import 'package:monkey_ride/providers/notifications_provider.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/localization/locale_provider.dart';
import 'app/theme/theme_provider.dart';
import 'firebase_options.dart';

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
        ChangeNotifierProvider(create: (_) => MapProvider()..loadMapData()),
        ChangeNotifierProvider(create: (_) => LocationProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()..initialize()),
      ],
      child: const MonkeyRideApp(),
    ),
  );
}