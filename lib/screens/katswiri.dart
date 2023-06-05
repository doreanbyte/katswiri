import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/bloc/bloc.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/screens/webview_screen.dart';
import 'package:katswiri/screens/job_tag_screen.dart';
import 'package:katswiri/sources/sources.dart';

import 'bottom_navigation.dart';
import 'job_detail_screen.dart';

class Katswiri extends StatelessWidget {
  const Katswiri({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HistoryBloc()),
        BlocProvider(create: (_) => SavedJobsBloc()),
        BlocProvider(create: (_) => JobSaveBloc()),
      ],
      child: MaterialApp(
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
        home: const BottomNavigationScreen(),
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
            case JobTagScreen.route:
              final arguments = settings.arguments as Map<String, dynamic>;
              final String title = arguments['title'] as String;
              final Map<String, String> filter =
                  arguments['filter'] as Map<String, String>;
              final int initialIndex = arguments['initialIndex'] as int;

              pageRoute = MaterialPageRoute(
                builder: (context) => JobTagScreen(
                  title: title,
                  filter: filter,
                  initialIndex: initialIndex,
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
      ),
    );
  }
}
