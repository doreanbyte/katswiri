part of 'theme_bloc.dart';

sealed class ThemeState {
  const ThemeState();
}

class LightTheme extends ThemeState {
  const LightTheme();
}

class DarkTheme extends ThemeState {
  const DarkTheme();
}

class AutoTheme extends ThemeState {
  const AutoTheme();
}
