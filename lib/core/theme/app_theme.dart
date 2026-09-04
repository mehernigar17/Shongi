import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: pageBackground,
  colorScheme: ColorScheme.fromSeed(
    seedColor: accentColor,
    primary: accentColor,
    surface: Colors.white,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: pageBackground,
    elevation: 0,
    centerTitle: false,
    iconTheme: const IconThemeData(color: textColor),
    titleTextStyle: GoogleFonts.poppins(
      color: textColor,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: const BorderSide(color: cardBorderColor),
    ),
  ),
);
