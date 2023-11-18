library theme_bloc;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/app_settings.dart';
import 'package:katswiri/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

final class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(super.themeState) {
    on<GetThemeEvent>(
      (event, emit) async {
        final themeSetting = await AppSettings.getTheme();

        switch (themeSetting) {
          case (PreferredTheme.auto):
            emit(const AutoTheme());
            break;
          case (PreferredTheme.light):
            emit(const LightTheme());
            break;
          case (PreferredTheme.dark):
            emit(const DarkTheme());
            break;
        }
      },
    );

    on<ChangedThemeEvent>(
      (event, emit) async {
        final selectedTheme = event.selectedTheme;

        switch (selectedTheme) {
          case (AutoTheme()):
            await AppSettings.setTheme(PreferredTheme.auto);
            break;
          case (LightTheme()):
            await AppSettings.setTheme(PreferredTheme.light);
            break;
          case (DarkTheme()):
            await AppSettings.setTheme(PreferredTheme.dark);
            break;
        }

        emit(selectedTheme);
      },
    );
  }
}
