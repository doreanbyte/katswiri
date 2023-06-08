part of 'theme_bloc.dart';

sealed class AppThemeState {
  const AppThemeState();
}

class InitialThemeState extends AppThemeState {
  const InitialThemeState();
}

class ThemeState extends AppThemeState {
  const ThemeState({required this.appTheme});

  final AppTheme appTheme;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeState &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(appTheme, other.appTheme);

  @override
  int get hashCode => const DeepCollectionEquality().hash(appTheme);
}
