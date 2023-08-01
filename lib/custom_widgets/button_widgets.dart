import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/app_settings.dart';
import 'package:katswiri/app_theme.dart';
import 'package:katswiri/bloc/bloc.dart';

class ToggleThemeButtons extends StatefulWidget {
  const ToggleThemeButtons(this.selectedThemeState, {super.key});

  final ThemeState selectedThemeState;

  @override
  State<ToggleThemeButtons> createState() => _ToggleThemeButtonsState();
}

class _ToggleThemeButtonsState extends State<ToggleThemeButtons> {
  String? _selectedTheme;

  @override
  void initState() {
    _selectedTheme = switch (widget.selectedThemeState) {
      AutoTheme() => PreferredTheme.auto.name,
      LightTheme() => PreferredTheme.light.name,
      DarkTheme() => PreferredTheme.dark.name,
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ...PreferredTheme.values
              .map<Widget>(
                (themePref) => RadioListTile(
                  title: Text(themePref.name),
                  value: themePref.name,
                  groupValue: _selectedTheme,
                  onChanged: (_) {
                    setState(() {
                      _selectedTheme = themePref.name;
                    });

                    switch (themePref) {
                      case PreferredTheme.auto:
                        context.read<ThemeBloc>().add(
                              const ChangedThemeEvent(
                                AutoTheme(),
                              ),
                            );
                        break;
                      case PreferredTheme.light:
                        context.read<ThemeBloc>().add(
                              const ChangedThemeEvent(
                                LightTheme(),
                              ),
                            );
                        break;
                      case PreferredTheme.dark:
                        context.read<ThemeBloc>().add(
                              const ChangedThemeEvent(
                                DarkTheme(),
                              ),
                            );
                        break;
                    }
                  },
                ),
              )
              .toList(),
        ],
      );
}

class ToggleJobViewButtons extends StatefulWidget {
  const ToggleJobViewButtons({super.key});

  @override
  State<ToggleJobViewButtons> createState() => _ToggleJobViewButtonsState();
}

class _ToggleJobViewButtonsState extends State<ToggleJobViewButtons> {
  String? _selectedView;

  @override
  Widget build(BuildContext context) => FutureBuilder<PreferredJobView>(
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

class RetryButton extends StatelessWidget {
  const RetryButton({required this.onRetryPressed, super.key});

  final void Function() onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onRetryPressed,
      icon: const Icon(Icons.refresh),
      iconSize: 38.0,
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
