import 'package:flutter/material.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/screens/webview_screen.dart';
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
        scaffoldBackgroundColor: Colors.black87,
        primarySwatch: Colors.green,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        iconTheme: IconTheme.of(context).copyWith(
          color: Colors.green,
        ),
        primaryColor: Colors.green,
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
          case WebViewScreen.route:
            final arguments = settings.arguments as Map<String, dynamic>;
            final String url = arguments['url'] as String;
            final String title = arguments['title'] as String;

            pageRoute = MaterialPageRoute(
              builder: (context) => WebViewScreen(
                title: title,
                url: url,
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
