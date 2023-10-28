import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
    fontFamily: GoogleFonts.roboto().fontFamily,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: Color(0xff15202B),
        primary: Color(0xff242037),
        secondary: Colors.purple,
        error: Colors.red,
        errorContainer: Colors.yellow),
    scaffoldBackgroundColor: Color(0xff15202B),
    canvasColor: Colors.grey[800],
    cardColor: Colors.grey[800],
    dividerColor: Colors.grey[600],
    appBarTheme: AppBarTheme(backgroundColor: Color(0xff15202B)),
    iconTheme: const IconThemeData(color: Colors.grey),
    indicatorColor: Colors.indigo,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 28, color: Colors.white, fontWeight: FontWeight.w700),
      ),
      displayMedium: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
      ),
      displaySmall: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 17, color: Colors.blueGrey, fontWeight: FontWeight.w400),
      ),
      bodyMedium: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 17, color: Colors.white, fontWeight: FontWeight.w400),
      ),
      bodySmall: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black, // FAB background color
    ));
