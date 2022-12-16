import 'package:flutter/material.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/screens/general_search_screen.dart';
import 'package:katswiri/sources/sources.dart';

import 'bottom_navigation.dart';
import 'job_detail_screen.dart';

class Katswiri extends StatelessWidget {
  const Katswiri({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katswiri',
      theme: ThemeData(
        backgroundColor: Colors.black12,
        scaffoldBackgroundColor: const Color(0xFF000000),
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      initialRoute: BottomNavigationScreen.route,
      onGenerateRoute: (settings) {
        final MaterialPageRoute pageRoute;
        final path = settings.name as String;

        switch (path) {
          case JobDetailScreen.route:
            final arguments = settings.arguments as Map<String, dynamic>;

            final job = arguments['job'] as Job;
            final source = arguments['source'] as Source;

            pageRoute = MaterialPageRoute(
              builder: (context) => JobDetailScreen(
                job: job,
                source: source,
              ),
            );
            break;
          case GeneralSearchScreen.route:
            final arguments = settings.arguments as Map<String, dynamic>;

            final String title = arguments['title'] as String;
            final Source source = arguments['source'] as Source;
            final Map<String, String> searchArgs =
                arguments['arguments'] as Map<String, String>;

            pageRoute = MaterialPageRoute(
              builder: (context) => GeneralSearchScreen(
                title,
                source: source,
                arguments: searchArgs,
              ),
            );
            break;
          default:
            pageRoute = MaterialPageRoute(
              builder: (context) => const BottomNavigationScreen(),
            );
        }

        return pageRoute;
      },
    );
  }
}
