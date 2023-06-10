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
      splashColor: switch (appTheme) {
        AppTheme.greenLight || AppTheme.greenDark => Colors.transparent,
      },
      highlightColor: switch (appTheme) {
        AppTheme.greenLight || AppTheme.greenDark => Colors.transparent,
      },
      brightness: switch (appTheme) {
        AppTheme.greenLight => Brightness.light,
        AppTheme.greenDark => Brightness.dark,
      },
      backgroundColor: switch (appTheme) {
        AppTheme.greenLight => Colors.white,
        AppTheme.greenDark => Colors.black12,
      },
      scaffoldBackgroundColor: switch (appTheme) {
        AppTheme.greenLight => Colors.white,
        AppTheme.greenDark => Colors.black87,
      },
      primarySwatch: switch (appTheme) {
        AppTheme.greenLight || AppTheme.greenDark => Colors.green,
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
      iconTheme: IconThemeData(
        color: switch (appTheme) {
          AppTheme.greenLight || AppTheme.greenDark => Colors.green,
        },
      ),
      primaryIconTheme: IconThemeData(
        color: switch (appTheme) {
          AppTheme.greenLight || AppTheme.greenDark => Colors.green,
        },
      ),
      primaryColor: switch (appTheme) {
        AppTheme.greenLight || AppTheme.greenDark => Colors.green,
      },
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
          AppTheme.greenLight => Colors.white,
          AppTheme.greenDark => const Color.fromARGB(96, 64, 64, 64),
        },
      ),
      secondaryHeaderColor: switch (appTheme) {
        AppTheme.greenLight || AppTheme.greenDark => Colors.grey,
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
          AppTheme.greenLight => Colors.grey,
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
    );
