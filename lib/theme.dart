import 'package:flutter/material.dart';

ThemeData buildTheme() {
  return ThemeData(
    primarySwatch: Colors.green,
    primaryColor: const Color(0xFF00B386), // Dark Forest Green
    useMaterial3: true,
   
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF00B386),
      secondary: Color(0xFFCCFFF2),
      tertiary: Color(0xFFECFFFA),
      background: Color(0xFFF0F8FF),
      surface: Color(0xFFFFFFFF),
      error: Color(0xFFC62828),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onBackground: Color(0xFF44475B),
      onSurface: Color(0xFF44475B),
      
      
      onError: Color(0xFFFFFFFF),
      brightness: Brightness.light,
    ),
    fontFamily: 'Roboto',
    // dividerColor: const Color(0xFF7C7E8C),
    dividerTheme: const DividerThemeData(
      space: 0,
      thickness: 1,
      color: Color(0xFFE5E5E5),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF44475B),
        //  overflow: TextOverflow.ellipsis
      ),
      displayMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xFF44475B),
        overflow: TextOverflow.ellipsis
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFF44475B),
        fontWeight: FontWeight.w500,
         overflow: TextOverflow.ellipsis
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF44475B),
        fontWeight: FontWeight.w500,
         overflow: TextOverflow.ellipsis
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Color(0xFF44475B),
        fontWeight: FontWeight.w500,
         overflow: TextOverflow.ellipsis
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xFF00B386),
      textTheme: ButtonTextTheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF00B386),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF7C7E8C),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00B386),
        foregroundColor: Colors.white,
        
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,

      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Color(0xFF00B386),
          width: 1,
        ),
      ),
      //remove on border text

      
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Color(0xFF00B386),
          width: 1,
          
          
        ),
      ),
      
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: Color(0xFF7C7E8C)),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.2),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(10),
    ),
  );
}
