library theme_bloc;

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const InitialThemeState()) {
    on<GetThemeEvent>(
      (event, emit) {},
    );

    on<ThemeChangedEvent>(
      (event, emit) {},
    );
  }
}
