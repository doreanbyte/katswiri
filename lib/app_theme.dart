import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

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
    scaffoldBackgroundColor: isDark ? Colors.black87 : const Color(0xFFF2F2F2),
    tabBarTheme: origin.tabBarTheme.copyWith(
      unselectedLabelColor: isDark ? Colors.white70 : Colors.black54,
    ),
    bottomNavigationBarTheme: origin.bottomNavigationBarTheme.copyWith(
      selectedItemColor: colorScheme.primary,
      backgroundColor:
          isDark ? const Color(0xFF000000) : const Color(0xFFF0F0F0),
      unselectedItemColor: Colors.grey,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: defScheme.onSurface,
      elevation: 0,
    ),
    dialogTheme: origin.dialogTheme.copyWith(
      backgroundColor: isDark ? Colors.black : const Color(0xFFFAFAFA),
    ),
    iconTheme: IconThemeData(
      color: colorScheme.primary,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    cardTheme: origin.cardTheme.copyWith(
      surfaceTintColor: isDark
          ? const Color.fromARGB(96, 64, 64, 64)
          : const Color(0xFFFAFAFA),
    ),
    secondaryHeaderColor: isDark ? Colors.grey : Colors.black54,
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
