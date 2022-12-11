import 'package:flutter/material.dart';

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
      ),
      initialRoute: BottomNavigationScreen.route,
      onGenerateRoute: (settings) {
        final MaterialPageRoute pageRoute;
        final path = settings.name as String;

        switch (path) {
          case JobDetailScreen.route:
            pageRoute = MaterialPageRoute(
              builder: (context) => const JobDetailScreen(),
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
