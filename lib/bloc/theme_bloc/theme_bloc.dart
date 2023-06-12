library theme_bloc;

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/app_settings.dart';
import 'package:katswiri/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, AppThemeState> {
  ThemeBloc() : super(const InitialThemeState()) {
    on<GetThemeEvent>(
      (event, emit) async {
        final theme = await AppSettings.getTheme();
        switch ((theme, event.isDark)) {
          case (PreferredTheme.auto, false) || (PreferredTheme.light, _):
            emit(const ThemeState(appTheme: AppTheme.greenLight));
            break;
          case (PreferredTheme.auto, true) || (PreferredTheme.dark, _):
            emit(const ThemeState(appTheme: AppTheme.greenDark));
            break;
        }
      },
    );

    on<ThemeChangedEvent>(
      (event, emit) {
        emit(
          ThemeState(
            appTheme: event.appTheme,
          ),
        );
      },
    );
  }
}
