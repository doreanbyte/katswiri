import 'package:flutter/material.dart';

enum AppTheme {
  greenLight,
  greenDark,
}

ThemeData buildAppTheme(BuildContext context, AppTheme appTheme) =>
    switch (appTheme) {
      AppTheme.greenLight => ThemeData(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.green,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
                displayColor: Colors.black,
              ),
          iconTheme: const IconThemeData(
            color: Colors.green,
          ),
          primaryColor: Colors.green,
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
            ),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.black,
          ),
          cardTheme: const CardTheme(
            color: Colors.white,
          ),
          secondaryHeaderColor: Colors.grey,
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color.fromARGB(255, 15, 9, 9),
          ),
          tabBarTheme: const TabBarTheme(
            unselectedLabelColor: Colors.white70,
            labelColor: Colors.green,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFFF0F0F0),
            unselectedItemColor: Colors.grey,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
          ),
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.white,
          ),
        ),
      AppTheme.greenDark => ThemeData(
          brightness: Brightness.dark,
          backgroundColor: Colors.black12,
          scaffoldBackgroundColor: Colors.black87,
          primarySwatch: Colors.green,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
          iconTheme: const IconThemeData(
            color: Colors.green,
          ),
          primaryColor: Colors.green,
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
            ),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white,
          ),
          cardTheme: const CardTheme(
            color: Color.fromARGB(96, 64, 64, 64),
          ),
          secondaryHeaderColor: Colors.grey,
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
          ),
          tabBarTheme: const TabBarTheme(
            unselectedLabelColor: Colors.white70,
            labelColor: Colors.green,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF000000),
            unselectedItemColor: Colors.grey,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
          ),
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.black,
          ),
        )
    };
