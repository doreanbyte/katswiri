part of 'theme_bloc.dart';

sealed class SelectedThemeState {
  const SelectedThemeState();
}

class SelectedLightTheme extends SelectedThemeState {
  const SelectedLightTheme();
}

class SelectedDarkTheme extends SelectedThemeState {
  const SelectedDarkTheme();
}

class SelectedAutoTheme extends SelectedThemeState {
  const SelectedAutoTheme();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedAutoTheme && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
