import 'package:flutter/material.dart';

enum PreferredTheme {
  auto('Auto'),
  light('Light'),
  dark('Dark');

  const PreferredTheme(this.name);

  final String name;
}

enum AppTheme {
  light,
  dark,
}

ThemeData buildAppTheme(
  BuildContext context,
  AppTheme appTheme,
) =>
    ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: switch (appTheme) {
        AppTheme.light => const Color(0xFFF2F2F2),
        AppTheme.dark => Colors.black87,
      },
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: switch (appTheme) {
              AppTheme.light => Colors.black,
              AppTheme.dark => Colors.white,
            },
            displayColor: switch (appTheme) {
              AppTheme.light => Colors.black,
              AppTheme.dark => Colors.white,
            },
          ),
      iconTheme: const IconThemeData(
        color: Colors.green,
      ),
      primaryIconTheme: const IconThemeData(
        color: Colors.green,
      ),
      primaryColor: Colors.green,
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: switch (appTheme) {
            AppTheme.light =>
              MaterialStateProperty.all<Color>(Colors.transparent),
            AppTheme.dark => MaterialStateProperty.all<Color>(Colors.green),
          },
          overlayColor: switch (appTheme) {
            AppTheme.light =>
              MaterialStateProperty.all<Color>(Colors.transparent),
            AppTheme.dark => MaterialStateProperty.all<Color>(Colors.green),
          },
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: switch (appTheme) {
          AppTheme.light => Colors.black,
          AppTheme.dark => Colors.white,
        },
      ),
      cardTheme: CardTheme(
        color: switch (appTheme) {
          AppTheme.light => Colors.white70,
          AppTheme.dark => const Color.fromARGB(96, 64, 64, 64),
        },
      ),
      secondaryHeaderColor: switch (appTheme) {
        AppTheme.light => Colors.black54,
        AppTheme.dark => Colors.grey,
      },
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: switch (appTheme) {
          AppTheme.light => const Color.fromARGB(255, 15, 9, 9),
          AppTheme.dark => Colors.white,
        },
      ),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: switch (appTheme) {
          AppTheme.light => Colors.black54,
          AppTheme.dark => Colors.white70,
        },
        labelColor: Colors.green,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: switch (appTheme) {
          AppTheme.light => const Color(0xFFF0F0F0),
          AppTheme.dark => const Color(0xFF000000),
        },
        unselectedItemColor: Colors.grey,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: switch (appTheme) {
          AppTheme.light => Colors.white,
          AppTheme.dark => Colors.black,
        },
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
      ).copyWith(
        background: switch (appTheme) {
          AppTheme.light => const Color(0xFFF2F2F2),
          AppTheme.dark => Colors.black12,
        },
      ),
    );
