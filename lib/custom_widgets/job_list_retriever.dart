import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/sources.dart';
import 'package:katswiri/utils/utils.dart';

class JobListRetriever extends StatefulWidget {
  const JobListRetriever({
    super.key,
    required this.source,
    this.filter,
  });

  final Source source;
  final Map<String, String>? filter;

  @override
  State<JobListRetriever> createState() => _JobListRetrieverState();
}

class _JobListRetrieverState extends State<JobListRetriever>
    with AutomaticKeepAliveClientMixin<JobListRetriever> {
  late final Source _source;
  final List<Job> _jobs = [];

  int _page = 1;
  bool _loading = true;
  bool _hasError = false;
  String _errMsg = '';

  late final StreamController<List<Job>> _streamController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _source = widget.source;
    _streamController = StreamController.broadcast();
    _streamController.stream.listen(_onData, onError: _onError);

    _scrollController = ScrollController()..addListener(_onScrollEnd);

    super.initState();
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
        ErrorButton(
          errorMessage: _errMsg,
          onRetryPressed: _onRetryPressed,
        ),
      );
    }

    if (_jobs.isEmpty && !_loading) {
      widgets.add(
        const Center(
          child: Text('No results found'),
        ),
      );
    }

    return RefreshIndicator(
      backgroundColor: Colors.black,
      onRefresh: _onRefresh,
      child: ListView.builder(
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
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
      final jobs = await _source.fetchJobs(
        page: _page,
        filter: widget.filter,
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
      setState(() {
        _loading = true;
      });

      _getJobs();
    }
  }

  void _onData(List<Job> jobs) {
    _jobs.addAll(jobs);
    _jobs.sort(
      (a, b) => postedDate(b).compareTo(postedDate(a)),
    );

    setState(() {
      _page++;
      _loading = false;
    });
  }

  void _onError(Object error, StackTrace stackTrace) {
    setState(() {
      _loading = false;
      _hasError = true;
      _errMsg = error.toString();
    });
  }

  void _onRetryPressed() {
    setState(() {
      _hasError = false;
      _errMsg = '';
      _loading = true;
    });

    _getJobs();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _jobs.clear();
      _page = 1;
      _loading = true;
      _errMsg = '';
    });

    _getJobs();
  }
}
