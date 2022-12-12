import 'package:flutter/material.dart';
import 'package:katswiri/sources/sources.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';

class ExploreJobsScreen extends StatefulWidget {
  const ExploreJobsScreen({super.key});

  static const route = '/explore_jobs';

  @override
  State<ExploreJobsScreen> createState() => _ExploreJobsScreenState();
}

class _ExploreJobsScreenState extends State<ExploreJobsScreen>
    with SingleTickerProviderStateMixin {
  final _sources = getSources();

  late final _tabController = TabController(
    length: _sources.length,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: _sources
              .map<Widget>((source) => Tab(
                    text: source.title,
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _sources
            .map<Widget>((source) => JobListRetriever(source: source))
            .toList(),
      ),
    );
  }
}
