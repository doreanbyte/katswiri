import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/sources.dart';

class JobListRetriever extends StatefulWidget {
  const JobListRetriever({
    super.key,
    required this.source,
    this.arguments,
  });

  final Source source;
  final Map<String, String>? arguments;

  @override
  State<JobListRetriever> createState() => _JobListRetrieverState();
}

class _JobListRetrieverState extends State<JobListRetriever>
    with AutomaticKeepAliveClientMixin<JobListRetriever> {
  late final Source _source;
  final List<Job> _jobs = [];

  int _page = 1;
  bool _loading = false;
  bool _hasError = false;

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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<List<Job>>(
      stream: _streamController.stream,
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, AsyncSnapshot<List<Job>> snapshot) {
    final List<Widget> widgets = _jobs
        .map<Widget>((job) => JobTile(
              job: job,
              source: _source,
            ))
        .toList();

    if (_loading) {
      widgets.add(
        const Spinner(),
      );
    }

    if (_hasError) {
      widgets.add(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _onRetryPressed,
                icon: const Icon(Icons.refresh),
                color: Colors.blue,
                iconSize: 38.0,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 4.0),
        itemBuilder: (context, index) {
          return widgets[index];
        },
        itemCount: widgets.length,
      ),
    );
  }

  void _getJobs() async {
    try {
      setState(() {
        _loading = true;
      });

      final jobs = await _source.fetchJobs(
        page: _page,
        arguments: widget.arguments,
      );
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
    if (offset >= maxScrollExtent && !_loading && !_hasError) {
      _getJobs();
    }
  }

  void _onData(List<Job> jobs) {
    _jobs.addAll(jobs);
    _jobs.sort((a, b) =>
        _postedDate(b).difference(_postedDate(a)).inSeconds.compareTo(0));

    setState(() {
      _page++;
      _loading = false;
    });
  }

  void _onError(Object object, StackTrace stackTrace) {
    _loading = false;
    setState(() {
      _hasError = true;
    });
  }

  void _onRetryPressed() {
    _hasError = false;
    _getJobs();
  }

  Future<void> _onRefresh() async {
    _jobs.clear();
    _page = 1;
    _getJobs();
  }
}

DateTime _postedDate(Job job) {
  var posted = job.posted.toLowerCase();
  posted = posted.replaceAll('posted', '').replaceAll('ago', '').trim();

  final period = int.tryParse(posted.split(' ').first);
  DateTime now = DateTime.now();

  if (period == null) {
    return now;
  }

  if (posted.contains('second')) {
    return now.subtract(
      Duration(seconds: period),
    );
  } else if (posted.contains('minute')) {
    return now.subtract(
      Duration(minutes: period),
    );
  } else if (posted.contains('hour')) {
    return now.subtract(
      Duration(hours: period),
    );
  } else if (posted.contains('day')) {
    return now.subtract(
      Duration(days: period),
    );
  } else if (posted.contains('week')) {
    return now.subtract(
      Duration(days: period * 7),
    );
  } else if (posted.contains('month')) {
    return now.subtract(
      Duration(days: period * 30),
    );
  } else if (posted.contains('year')) {
    return now.subtract(
      Duration(days: period * 365),
    );
  } else {
    return now;
  }
}
