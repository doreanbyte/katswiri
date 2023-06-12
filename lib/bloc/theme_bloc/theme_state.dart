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
  const SelectedAutoTheme({required this.isDark});

  final bool isDark;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedAutoTheme &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(
            isDark,
            other.isDark,
          );

  @override
  int get hashCode => const DeepCollectionEquality().hash(isDark);
}
