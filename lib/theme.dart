import 'package:crypt_chat/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: Constants.kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Constants.kContentColorLightTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: Constants.kContentColorLightTheme),
    colorScheme: ColorScheme.light(
      primary: Constants.kPrimaryColor,
      secondary: Constants.kSecondaryColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      selectedItemColor: Constants.kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: Constants.kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: Constants.kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: Constants.kPrimaryColor,
    scaffoldBackgroundColor: Constants.kContentColorLightTheme,
    hintColor: Colors.black54,
    iconTheme: IconThemeData(color: Constants.kContentColorDarkTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: Constants.kContentColorDarkTheme),
    colorScheme: ColorScheme.dark().copyWith(
      primary: Constants.kPrimaryColor,
      secondary: Constants.kSecondaryColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Constants.kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      unselectedItemColor: Constants.kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: Constants.kSecondaryColor),
      showUnselectedLabels: true,
    ),
  );
}
