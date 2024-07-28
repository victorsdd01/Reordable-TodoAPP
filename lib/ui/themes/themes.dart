


import 'package:flutter/material.dart';

class AppTheme{

  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: const Color(0xff5539dc),
    scaffoldBackgroundColor:const Color(0xfffafafc),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 16,
        fontWeight: FontWeight.w300,
        
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder( 
        borderRadius: BorderRadius.circular(5.0),
        borderSide:  BorderSide(
          color: ThemeData.light().primaryColor
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red
        ),
        borderRadius: BorderRadius.circular(5.0)
      ),
    ),
    dividerTheme: DividerThemeData(
      space: 0.0,
      
      color: Colors.grey.shade400
    ),
    cardTheme:  CardTheme(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStatePropertyAll(ThemeData.light().primaryColor),
      checkColor: WidgetStatePropertyAll(ThemeData.light().primaryColor),
      
    )
  );
}