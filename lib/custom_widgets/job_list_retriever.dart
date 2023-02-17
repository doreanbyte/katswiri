import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/sources.dart';
import 'job_model_widgets.dart';

class JobListRetriever extends StatefulWidget {
  const JobListRetriever({
    super.key,
    required this.source,
    this.arguments,
    this.scrollController,
  });

  final Source source;
  final Map<String, String>? arguments;
  final ScrollController? scrollController;

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
  late final ScrollController _listScrollController;

  @override
  void initState() {
    super.initState();
    _source = widget.source;
    _streamController = StreamController.broadcast();
    _streamController.stream.listen(_onData, onError: _onError);

    _listScrollController = ScrollController()..addListener(_onScrollEnd);

    _getJobs();
  }

  @override
  void dispose() {
    _streamController.close();
    _listScrollController.removeListener(_onScrollEnd);
    _listScrollController.dispose();

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
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .80,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: JobsList(
            _jobs,
            loading: _loading,
            error: _hasError,
            onRetryPressed: _onRetryPressed,
            controller: _listScrollController,
            source: _source,
          ),
        ),
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
    final offset = _listScrollController.offset;
    final maxScrollExtent = _listScrollController.position.maxScrollExtent;

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
