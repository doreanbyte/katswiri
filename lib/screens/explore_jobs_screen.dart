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
  final List<Widget> _widgets = [];

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
      // Go through every result from stream and turn it into it's relevevant
      // widget in this case a job tile
      jobs.forEach((job) {
        _widgets.add(_JobTile(job: job));
      });

      setState(() {
        _page++;
        _loading = false;
      });
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
    return StreamBuilder<List<Job>>(
      stream: _streamController.stream,
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, AsyncSnapshot<List<Job>> snapshot) {
    final widgets = _widgets.map<Widget>((widget) => widget).toList();

    if (_loading) {
      widgets.add(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          return widgets[index];
        });
  }

  void _getJobs() async {
    try {
      setState(() {
        _loading = true;
      });
      final jobs = await _source.fetchJobs(page: _page);
      _streamController.sink.add(jobs);
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

class _JobTile extends StatefulWidget {
  const _JobTile({super.key, required this.job});

  final Job job;

  @override
  State<_JobTile> createState() => __JobTileState();
}

class __JobTileState extends State<_JobTile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
