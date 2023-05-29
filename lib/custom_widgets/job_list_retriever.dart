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
  bool _refresh = false;

  late final StreamController<List<Job>> _streamController =
      StreamController.broadcast();
  late final ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _source = widget.source;
    _streamController.stream.listen(
      _onData,
      onError: _onError,
    );

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
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<List<Job>>(
      stream: _streamController.stream,
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, _) {
    final Widget child;

    if (_loading && _jobs.isEmpty) {
      child = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final List<Widget> widgetList = _jobs
          .map<Widget>((job) => JobTile(
                job: job,
                source: _source,
              ))
          .toList();

      if (_loading) {
        widgetList.add(
          const Spinner(),
        );
      }

      if (_hasError) {
        widgetList.add(
          ErrorButton(
            errorMessage: _errMsg,
            onRetryPressed: _onRetryPressed,
          ),
        );
      }

      if (_jobs.isEmpty && !_loading && _errMsg.isEmpty) {
        widgetList.add(
          const Center(
            child: Text('No Results Found'),
          ),
        );
      }

      child = Center(
        child: ListView.builder(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 4.0),
          itemBuilder: (context, index) => widgetList[index],
          itemCount: widgetList.length,
        ),
      );
    }

    return RefreshIndicator(
      backgroundColor: Colors.black,
      onRefresh: _onRefresh,
      child: child,
    );
  }

  void _getJobs() async {
    try {
      final jobs = await _source.fetchJobs(
        page: _page,
        filter: widget.filter,
        refresh: _refresh,
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
      (a, b) => postedDate(b.posted).compareTo(postedDate(a.posted)),
    );

    setState(() {
      _page++;
      _loading = false;
      _refresh = false;
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
      _refresh = true;
    });

    _getJobs();
  }
}
