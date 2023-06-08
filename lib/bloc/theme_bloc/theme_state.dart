part of 'theme_bloc.dart';

sealed class AppThemeState {
  const AppThemeState();
}

class InitialThemeState extends AppThemeState {
  const InitialThemeState();
}

class ThemeState extends AppThemeState {
  const ThemeState(this.themeData);

  final ThemeData themeData;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeState &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(themeData, other.themeData);

  @override
  int get hashCode => const DeepCollectionEquality().hash(themeData);
}
