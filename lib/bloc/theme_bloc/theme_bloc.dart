library theme_bloc;

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/app_settings.dart';
import 'package:katswiri/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, SelectedThemeState> {
  ThemeBloc() : super(const SelectedAutoTheme(isDark: false)) {
    on<GetThemeEvent>(
      (event, emit) async {
        final themeSetting = await AppSettings.getTheme();
        final isDark = event.isDark;

        switch (themeSetting) {
          case (PreferredTheme.auto):
            emit(SelectedAutoTheme(isDark: isDark));
            break;
          case (PreferredTheme.light):
            emit(const SelectedLightTheme());
            break;
          case (PreferredTheme.dark):
            emit(const SelectedDarkTheme());
            break;
        }
      },
    );

    on<ChangedThemeEvent>(
      (event, emit) async {
        final selectedTheme = event.selectedTheme;

        switch (selectedTheme) {
          case (SelectedAutoTheme()):
            await AppSettings.setTheme(PreferredTheme.auto);
            break;
          case (SelectedLightTheme()):
            await AppSettings.setTheme(PreferredTheme.light);
            break;
          case (SelectedDarkTheme()):
            await AppSettings.setTheme(PreferredTheme.dark);
            break;
        }

        emit(selectedTheme);
      },
    );
  }
}
