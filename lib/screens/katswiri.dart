import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/app_settings.dart';
import 'package:katswiri/app_theme.dart';
import 'package:katswiri/bloc/bloc.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/screens/about_screen.dart';
import 'package:katswiri/screens/webview_screen.dart';
import 'package:katswiri/screens/job_tag_screen.dart';
import 'package:katswiri/sources/sources.dart';

import 'bottom_navigation.dart';
import 'job_detail_screen.dart';

class Katswiri extends StatelessWidget {
  const Katswiri({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppSettings.getTheme(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        final SelectedThemeState selectedTheme = switch (snapshot.data!) {
          PreferredTheme.auto => const SelectedAutoTheme(),
          PreferredTheme.light => const SelectedLightTheme(),
          PreferredTheme.dark => const SelectedDarkTheme(),
        };

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => HistoryBloc()..add(const FetchHistory()),
            ),
            BlocProvider(
              create: (_) => SavedJobsBloc()..add(const FetchSavedJobs()),
            ),
            BlocProvider(
              create: (_) => SaveJobBloc()..add(const CheckSavedJobs()),
            ),
            BlocProvider(
              create: (_) => ThemeBloc(selectedTheme)
                ..add(
                  const GetThemeEvent(),
                ),
            ),
          ],
          child: BlocBuilder<ThemeBloc, SelectedThemeState>(
            builder: _buildWithTheme,
          ),
        );
      },
    );
  }

  Widget _buildWithTheme(BuildContext context, SelectedThemeState state) =>
      AppThemeBuilder(
        builder: (context, appTheme) {
          return MaterialApp(
            title: 'Katswiri',
            debugShowCheckedModeBanner: false,
            theme: appTheme.lightTheme,
            darkTheme: appTheme.darkTheme,
            themeMode: switch (state) {
              SelectedAutoTheme() => ThemeMode.system,
              SelectedLightTheme() => ThemeMode.light,
              SelectedDarkTheme() => ThemeMode.dark,
            },
            home: const BottomNavigationScreen(),
            onGenerateRoute: (settings) => switch ((
              settings.name,
              settings.arguments,
            )) {
              (
                JobDetailScreen.route,
                {
                  'job': Job job,
                  'source': Source source,
                }
              ) =>
                MaterialPageRoute(
                  builder: (context) =>
                      JobDetailScreen(job: job, source: source),
                ),
              (
                WebViewScreen.route,
                {
                  'url': String url,
                  'title': String title,
                }
              ) =>
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(title: title, url: url),
                ),
              (
                JobTagScreen.route,
                {
                  'title': String title,
                  'filter': Map<String, String> filter,
                  'initialIndex': int initialIndex
                }
              ) =>
                MaterialPageRoute(
                  builder: (context) => JobTagScreen(
                    title: title,
                    filter: filter,
                    initialIndex: initialIndex,
                  ),
                ),
              (AboutScreen.route, _) => MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              (_, _) => MaterialPageRoute(
                  builder: (context) => const BottomNavigationScreen(),
                )
            },
          );
        },
      );
}
