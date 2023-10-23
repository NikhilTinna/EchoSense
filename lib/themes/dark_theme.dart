import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: Color(0xff15202B),
        primary: Colors.white,
        secondary: Color(0xff8B98A5),
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
      backgroundColor: Colors.black, // FAB background color
    ));
