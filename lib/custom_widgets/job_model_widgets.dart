import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katswiri/models/job.dart';
import 'package:katswiri/sources/sources.dart';

class JobListRetriever extends StatefulWidget {
  const JobListRetriever({super.key, required this.source});

  final Source source;

  @override
  State<JobListRetriever> createState() => _JobListRetrieverState();
}

class _JobListRetrieverState extends State<JobListRetriever> {
  late final Source _source;
  final List<Job> _jobs = [];

  int _page = 1;
  bool _loading = false;
  bool _error = false;

  late final StreamController<List<Job>> _streamController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _source = widget.source;
    _streamController = StreamController.broadcast();

    _streamController.stream.listen(_onData, onError: _onError);

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
    return JobsList(
      _jobs,
      loading: _loading,
      error: _error,
      onRefreshPressed: _onRefreshPressed,
      controller: _scrollController,
    );
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

    // If offset is equal to or greater than max scroll extent and the _loading
    // field is not set to true and the _error field is not set to true indicating
    // an error occured. Call _getJobs to fetch extra data
    if (offset >= maxScrollExtent && !_loading && !_error) {
      _getJobs();
    }
  }

  void _onData(List<Job> jobs) {
    _jobs.addAll(jobs);

    setState(() {
      _page++;
      _loading = false;
    });
  }

  void _onError(Object object, StackTrace stackTrace) {
    setState(() {
      _error = true;
    });
  }

  void _onRefreshPressed() {
    _error = false;
    _getJobs();
  }
}

class JobsList extends StatefulWidget {
  const JobsList(
    this.jobs, {
    super.key,
    required this.loading,
    required this.error,
    required this.onRefreshPressed,
    required this.controller,
  });

  final List<Job> jobs;
  final bool loading;
  final bool error;
  final void Function() onRefreshPressed;
  final ScrollController controller;

  @override
  State<JobsList> createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  late final List<Job> _jobs;

  @override
  void initState() {
    super.initState();
    _jobs = widget.jobs;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets =
        _jobs.map<Widget>((job) => JobTile(job: job)).toList();

    if (widget.loading) {
      widgets.add(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.error) {
      widgets.add(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: widget.onRefreshPressed,
                icon: const Icon(Icons.refresh),
              ),
              const Text('Something went wrong'),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
        controller: widget.controller,
        padding: const EdgeInsets.all(20),
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          return widgets[index];
        });
  }
}

class JobTile extends StatefulWidget {
  const JobTile({super.key, required this.job});

  final Job job;

  @override
  State<JobTile> createState() => _JobTileState();
}

class _JobTileState extends State<JobTile> {
  late final Job _job;

  @override
  void initState() {
    super.initState();

    _job = widget.job;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
