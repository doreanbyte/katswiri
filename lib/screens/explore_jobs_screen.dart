import 'package:flutter/material.dart';
import 'package:katswiri/sources/sources.dart';

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
        bottom: TabBar(
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
        children:
            _sources.map<Widget>((source) => _JobList(source: source)).toList(),
      ),
    );
  }
}

class _JobList extends StatefulWidget {
  const _JobList({super.key, required this.source});

  final Source source;

  @override
  State<_JobList> createState() => __JobListState();
}

class __JobListState extends State<_JobList> {
  late final Source _source;

  @override
  void initState() {
    super.initState();
    _source = widget.source;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_source.title),
    );
  }
}
