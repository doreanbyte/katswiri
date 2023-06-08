part of 'theme_bloc.dart';

sealed class ThemeState {
  const ThemeState();
}

class InitialThemeState extends ThemeState {
  const InitialThemeState();
}

class AppThemeState extends ThemeState {
  const AppThemeState(this.themeData);

  final ThemeData themeData;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeState &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(themeData, other.themeData);

  @override
  int get hashCode => const DeepCollectionEquality().hash(themeData);
}
