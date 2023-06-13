import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/app_settings.dart';
import 'package:katswiri/app_theme.dart';
import 'package:katswiri/bloc/bloc.dart';

class ToggleThemeButtons extends StatefulWidget {
  const ToggleThemeButtons(this.selectedThemeState, {super.key});

  final SelectedThemeState selectedThemeState;

  @override
  State<ToggleThemeButtons> createState() => _ToggleThemeButtonsState();
}

class _ToggleThemeButtonsState extends State<ToggleThemeButtons> {
  String? _selectedTheme;

  @override
  void initState() {
    _selectedTheme = switch (widget.selectedThemeState) {
      SelectedAutoTheme() => PreferredTheme.auto.name,
      SelectedLightTheme() => PreferredTheme.light.name,
      SelectedDarkTheme() => PreferredTheme.dark.name,
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          title: Text(PreferredTheme.auto.name),
          value: PreferredTheme.auto.name,
          groupValue: _selectedTheme,
          onChanged: (_) {
            setState(() {
              _selectedTheme = PreferredTheme.auto.name;
            });

            context.read<ThemeBloc>().add(
                  ChangedThemeEvent(
                    SelectedAutoTheme(
                      isDark: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark,
                    ),
                  ),
                );
          },
        ),
        RadioListTile<String>(
          title: Text(PreferredTheme.light.name),
          value: PreferredTheme.light.name,
          groupValue: _selectedTheme,
          onChanged: (_) {
            setState(() {
              _selectedTheme = PreferredTheme.light.name;
            });

            context.read<ThemeBloc>().add(
                  const ChangedThemeEvent(
                    SelectedLightTheme(),
                  ),
                );
          },
        ),
        RadioListTile<String>(
          title: Text(PreferredTheme.dark.name),
          value: PreferredTheme.dark.name,
          groupValue: _selectedTheme,
          onChanged: (_) {
            setState(() {
              _selectedTheme = PreferredTheme.dark.name;
            });

            context.read<ThemeBloc>().add(
                  const ChangedThemeEvent(
                    SelectedDarkTheme(),
                  ),
                );
          },
        ),
      ],
    );
  }
}

class ToggleJobViewButtons extends StatefulWidget {
  const ToggleJobViewButtons({super.key});

  @override
  State<ToggleJobViewButtons> createState() => _ToggleJobViewButtonsState();
}

class _ToggleJobViewButtonsState extends State<ToggleJobViewButtons> {
  String? _selectedView;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PreferredJobView>(
      future: AppSettings.getJobView(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        _selectedView ??= snapshot.data?.name;

        return Column(
          children: [
            ...PreferredJobView.values
                .map<Widget>(
                  (view) => RadioListTile<String>(
                    title: Text(view.name),
                    value: view.name,
                    groupValue: _selectedView,
                    onChanged: (_) async {
                      await AppSettings.setJobView(view);
                      setState(() {
                        _selectedView = view.name;
                      });
                    },
                  ),
                )
                .toList(),
          ],
        );
      },
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
