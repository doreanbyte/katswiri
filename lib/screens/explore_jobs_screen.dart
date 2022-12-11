import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katswiri/models/job.dart';
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
  final List<Job> _jobs = [];
  int _page = 1;
  bool _loading = false;

  late final StreamController<List<Job>> _streamController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _source = widget.source;
    _streamController = StreamController.broadcast();

    _streamController.stream.listen((jobs) {
      _jobs.addAll(jobs);
      setState(() => _loading = false);
    });

    _scrollController = ScrollController()..addListener(_onScrollEnd);

    _getJobs();
  }

  @override
  void dispose() {
    _streamController.close();
    _scrollController.removeListener(_onScrollEnd);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_source.title),
    );
  }

  void _getJobs() async {
    try {
      final jobs = await _source.fetchJobs(page: _page);
      _streamController.sink.add(jobs);
      setState(() {
        _page++;
        _loading = false;
      });
    } catch (e) {
      _streamController.addError(e);
    }
  }

  void _onScrollEnd() {
    final offset = _scrollController.offset;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;

    if (offset >= maxScrollExtent && !_loading) {
      _getJobs();
    }
  }
}
