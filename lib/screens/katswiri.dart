import 'package:flutter/material.dart';
import 'package:katswiri/models/job.dart';

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
            final job = settings.arguments as Job;
            pageRoute = MaterialPageRoute(
              builder: (context) => JobDetailScreen(job: job),
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
