import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/bloc/bloc.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart'
    show ToggleThemeButtons, ToggleJobViewButtons;
import 'package:katswiri/screens/about_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToggleThemeSection(),
          SizedBox(height: 8.0),
          _ToggleJobViewSection(),
          _InformationSection(),
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

class _ToggleJobViewSection extends StatelessWidget {
  const _ToggleJobViewSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Select Preferred View',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const ToggleJobViewButtons(),
          ),
        ),
      ],
    );
  }
}

class _InformationSection extends StatelessWidget {
  const _InformationSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Information',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTapUp: (_) {
                    Navigator.of(context).pushNamed(
                      AboutScreen.route,
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.info,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('About'),
                  ),
                ),
                const Divider(),
                GestureDetector(
                  onTapUp: (_) {},
                  child: ListTile(
                    leading: Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
