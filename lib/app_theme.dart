import 'package:flutter/material.dart';

enum AppTheme {
  greenLight,
  greenDark,
}

ThemeData buildAppTheme(
  BuildContext context,
  AppTheme appTheme,
) =>
    ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: switch (appTheme) {
        AppTheme.greenLight => const Color(0xFFF2F2F2),
        AppTheme.greenDark => Colors.black87,
      },
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: switch (appTheme) {
              AppTheme.greenLight => Colors.black,
              AppTheme.greenDark => Colors.white,
            },
            displayColor: switch (appTheme) {
              AppTheme.greenLight => Colors.black,
              AppTheme.greenDark => Colors.white,
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
            AppTheme.greenLight =>
              MaterialStateProperty.all<Color>(Colors.transparent),
            AppTheme.greenDark =>
              MaterialStateProperty.all<Color>(Colors.green),
          },
          overlayColor: switch (appTheme) {
            AppTheme.greenLight =>
              MaterialStateProperty.all<Color>(Colors.transparent),
            AppTheme.greenDark =>
              MaterialStateProperty.all<Color>(Colors.green),
          },
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: switch (appTheme) {
          AppTheme.greenLight => Colors.black,
          AppTheme.greenDark => Colors.white,
        },
      ),
      cardTheme: CardTheme(
        color: switch (appTheme) {
          AppTheme.greenLight => Colors.white70,
          AppTheme.greenDark => const Color.fromARGB(96, 64, 64, 64),
        },
      ),
      secondaryHeaderColor: switch (appTheme) {
        AppTheme.greenLight => Colors.black54,
        AppTheme.greenDark => Colors.grey,
      },
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: switch (appTheme) {
          AppTheme.greenLight => const Color.fromARGB(255, 15, 9, 9),
          AppTheme.greenDark => Colors.white,
        },
      ),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: switch (appTheme) {
          AppTheme.greenLight => Colors.black54,
          AppTheme.greenDark => Colors.white70,
        },
        labelColor: Colors.green,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: switch (appTheme) {
          AppTheme.greenLight => const Color(0xFFF0F0F0),
          AppTheme.greenDark => const Color(0xFF000000),
        },
        unselectedItemColor: Colors.grey,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: switch (appTheme) {
          AppTheme.greenLight => Colors.white,
          AppTheme.greenDark => Colors.black,
        },
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
      ).copyWith(
        background: switch (appTheme) {
          AppTheme.greenLight => const Color(0xFFF2F2F2),
          AppTheme.greenDark => Colors.black12,
        },
      ),
    );
