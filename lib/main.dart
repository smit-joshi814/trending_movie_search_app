import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_app/screens/home_screen.dart';
import 'package:movie_app/services/favourits_manager.dart';
import 'package:movie_app/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets are initialized.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(prefs: prefs));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
  }
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        appBarTheme: AppBarTheme(
            color: Colors.blueAccent.shade100,
            elevation: 5.0,
            scrolledUnderElevation: 1.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ))),
        cardTheme: movieCardTheme(),
        useMaterial3: true,
      ),
      home: HomeScreen(favoritesManager: FavoritesManager(prefs)),
    );
  }
}
