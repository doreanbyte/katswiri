library theme_bloc;

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, AppThemeState> {
  ThemeBloc() : super(const InitialThemeState()) {
    on<GetThemeEvent>(
      (event, emit) {
        emit(const ThemeState(appTheme: AppTheme.greenLight));
      },
    );

    on<ThemeChangedEvent>(
      (event, emit) {
        emit(ThemeState(appTheme: event.appTheme));
      },
    );
  }
}
