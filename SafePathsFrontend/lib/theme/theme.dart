import 'package:flutter/material.dart';

class AppTheme {
  static const Color _appColor = Color.fromRGBO(0, 0, 0, 1.0);

  static ThemeData get light {
    Color cardColor = const Color.fromRGBO(26, 232, 52, 1.0);
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: _appColor,
            secondary: _appColor,
            brightness: Brightness.light,
          ),
      cardColor: cardColor,
      dividerTheme: DividerThemeData(
        color: Colors.black.withOpacity(0.25),
        thickness: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        backgroundColor: cardColor,
      ),
    );
  }

  static ThemeData get dark {
    Color cardColor = const Color.fromRGBO(30, 30, 30, 1.0);
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFF000000),
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: _appColor,
            secondary: _appColor,
            brightness: Brightness.dark,
          ),
      cardColor: cardColor,
      dividerTheme: const DividerThemeData(
        color: Color(0x2FFFFFFF),
        thickness: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        backgroundColor: cardColor,
      ),
    );
  }
}
