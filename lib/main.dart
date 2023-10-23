import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/themes/dark_theme.dart';
import 'package:social_media/themes/light_theme.dart';
import 'package:social_media/views/authentication/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: Login());
  }
}
