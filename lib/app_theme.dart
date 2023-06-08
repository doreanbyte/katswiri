import 'package:flutter/material.dart';

enum AppTheme {
  greenLight,
  greenDark,
}

ThemeData buildAppTheme(BuildContext context, AppTheme appTheme) =>
    switch (appTheme) {
      AppTheme.greenLight => ThemeData(
          backgroundColor: Colors.black12,
          scaffoldBackgroundColor: Colors.black87,
          primarySwatch: Colors.green,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
          iconTheme: IconTheme.of(context).copyWith(
            color: Colors.green,
          ),
          primaryColor: Colors.green,
        ),
      AppTheme.greenDark => ThemeData(
          backgroundColor: Colors.black12,
          scaffoldBackgroundColor: Colors.black87,
          primarySwatch: Colors.green,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
          iconTheme: IconTheme.of(context).copyWith(
            color: Colors.green,
          ),
          primaryColor: Colors.green,
        ),
    };
