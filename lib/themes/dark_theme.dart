import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: Color(0xff15202B),
        primary: Color(0xff242037),
        secondary: Colors.purple,
        error: Colors.red,
        errorContainer: Colors.yellow),
    scaffoldBackgroundColor: Colors.grey[900],
    canvasColor: Colors.grey[800],
    cardColor: Colors.grey[800],
    dividerColor: Colors.grey[600],
    primarySwatch: Colors.indigo,
    iconTheme: const IconThemeData(color: Colors.indigo),
    indicatorColor: Colors.indigo,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 28, color: Colors.white, fontWeight: FontWeight.w700),
      ),
      bodyMedium: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
      ),
      bodySmall: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black, // FAB background color
    ));
