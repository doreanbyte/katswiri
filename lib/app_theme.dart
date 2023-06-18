import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

enum PreferredTheme {
  auto('Auto'),
  light('Light'),
  dark('Dark');

  const PreferredTheme(this.name);

  final String name;
}

const defaultAccent = Colors.green;

final lightScheme = ColorScheme.fromSeed(
  seedColor: defaultAccent,
  brightness: Brightness.light,
);

final darkScheme = ColorScheme.fromSeed(
  seedColor: defaultAccent,
  brightness: Brightness.dark,
);

ThemeData buildTheme({ColorScheme? scheme, required Brightness brightness}) {
  final isDark = brightness == Brightness.dark;
  final defScheme = isDark ? darkScheme : lightScheme;
  final colorScheme = scheme?.harmonized() ?? defScheme;
  final origin = isDark ? ThemeData.dark() : ThemeData.light();

  return origin.copyWith(
    useMaterial3: true,
    colorScheme: colorScheme.copyWith(background: colorScheme.surface),
    scaffoldBackgroundColor:
        isDark ? colorScheme.surface.darken(2) : colorScheme.surface,
    // tabBarTheme: TabBarTheme(
    //   unselectedLabelColor: switch (appTheme) {
    //     AppTheme.light => Colors.black54,
    //     AppTheme.dark => Colors.white70,
    //   },
    //   labelColor: Colors.green,
    // ),
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   backgroundColor: switch (appTheme) {
    //     AppTheme.light => const Color(0xFFF0F0F0),
    //     AppTheme.dark => const Color(0xFF000000),
    //   },
    //   unselectedItemColor: Colors.grey,
    //   selectedItemColor: Colors.green,
    // ),
    // appBarTheme: const AppBarTheme(
    //   backgroundColor: Colors.transparent,
    // ),
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? defScheme.surface.darken(2) : defScheme.surface,
      foregroundColor: defScheme.onSurface,
      elevation: 0,
    ),
    // dialogTheme: DialogTheme(
    //   backgroundColor: switch (appTheme) {
    //     AppTheme.light => const Color(0xFFFAFAFA),
    //     AppTheme.dark => Colors.black,
    //   },
    // ),
  );
}

({ThemeData lightTheme, ThemeData darkTheme}) fillWith({
  ColorScheme? light,
  ColorScheme? dark,
}) {
  return (
    lightTheme: buildTheme(scheme: light, brightness: Brightness.light),
    darkTheme: buildTheme(scheme: dark, brightness: Brightness.dark)
  );
}
