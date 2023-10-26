import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        background: Colors.white,
        primary: Colors.black,
        secondary: Color(0xff536471),
        error: Colors.red,
        errorContainer: Colors.yellow),
    scaffoldBackgroundColor: Colors.grey[900],
    canvasColor: Colors.grey[800],
    cardColor: Colors.grey[800],
    dividerColor: Colors.grey[600],
    primarySwatch: Colors.indigo,
    iconTheme: const IconThemeData(color: Colors.indigo),
    indicatorColor: Colors.indigo,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 24, color: Color(0xff8B98A5)),
      bodyLarge: TextStyle(color: Colors.black), // Body text color
      bodySmall: TextStyle(color: Colors.grey),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white, // FAB background color
    ));
