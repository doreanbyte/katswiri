import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/bloc/bloc.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart'
    show ToggleThemeButtons;

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToggleThemeSection(),
        ],
      ),
    );
  }
}

class _ToggleThemeSection extends StatelessWidget {
  const _ToggleThemeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Theme Settings',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Theme.of(context).cardTheme.color,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<ThemeBloc, SelectedThemeState>(
              builder: (context, state) => ToggleThemeButtons(state),
            ),
          ),
        ),
      ],
    );
  }
}