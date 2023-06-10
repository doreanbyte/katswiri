import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/bloc/bloc.dart';
import 'package:katswiri/app_theme.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: BlocBuilder<ThemeBloc, AppThemeState>(
        builder: (context, state) {
          if (state case ThemeState(appTheme: final appTheme)) {
            return switch (appTheme) {
              AppTheme.greenLight => IconButton(
                  key: const ValueKey('green_light'),
                  onPressed: () => context
                      .read<ThemeBloc>()
                      .add(const ThemeChangedEvent(AppTheme.greenDark)),
                  icon: const Icon(Icons.bookmark_rounded),
                  color: Theme.of(context).primaryColor,
                ),
              AppTheme.greenDark => IconButton(
                  key: const ValueKey('green_dark'),
                  onPressed: () => context.read<ThemeBloc>().add(
                        const ThemeChangedEvent(AppTheme.greenLight),
                      ),
                  icon: const Icon(Icons.bookmark_rounded),
                  color: Theme.of(context).primaryColor,
                ),
            };
          }

          return Container();
        },
      ),
    );
  }
}

class RetryButton extends StatelessWidget {
  const RetryButton({required this.onRetryPressed, super.key});

  final void Function() onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onRetryPressed,
      icon: const Icon(Icons.refresh),
      color: Theme.of(context).primaryColor,
      iconSize: 38.0,
      splashColor: Theme.of(context).splashColor,
      highlightColor: Theme.of(context).highlightColor,
    );
  }
}

class ErrorButton extends StatelessWidget {
  const ErrorButton({
    required this.errorMessage,
    required this.onRetryPressed,
    super.key,
  });

  final String errorMessage;
  final void Function() onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RetryButton(onRetryPressed: onRetryPressed),
          const SizedBox(height: 8.0),
          Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
