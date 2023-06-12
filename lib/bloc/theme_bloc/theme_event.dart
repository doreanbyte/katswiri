part of 'theme_bloc.dart';

sealed class ThemeEvent {
  const ThemeEvent();
}

class GetThemeEvent extends ThemeEvent {
  const GetThemeEvent(this.isDark);

  final bool isDark;
}

class ChangedThemeEvent extends ThemeEvent {
  const ChangedThemeEvent(this.selectedTheme);

  final SelectedThemeState selectedTheme;
}
