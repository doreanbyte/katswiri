part of 'theme_bloc.dart';

sealed class ThemeEvent {
  const ThemeEvent();
}

class GetThemeEvent extends ThemeEvent {
  const GetThemeEvent(this.isDark);

  final bool isDark;
}

class ThemeChangedEvent extends ThemeEvent {
  const ThemeChangedEvent(this.theme, this.appTheme);

  final PreferredTheme theme;
  final AppTheme appTheme;
}
