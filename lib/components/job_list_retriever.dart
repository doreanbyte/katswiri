import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katswiri/components/components.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/sources.dart';

class JobListingsRetriever extends StatefulWidget {
  const JobListingsRetriever({
    super.key,
    required this.source,
    this.filter,
    this.primary,
  });

  final Source source;
  final Map<String, String>? filter;
  final bool? primary;

  @override
  State<JobListingsRetriever> createState() => _JobListingsRetrieverState();
}

class _JobListingsRetrieverState extends State<JobListingsRetriever>
    with AutomaticKeepAliveClientMixin<JobListingsRetriever> {
  late final Source _source;
  final List<Job> _jobs = [];

  int _page = 1;
  bool _loading = true;
  bool _hasError = false;
  String _errMsg = '';
  bool _showScrollTop = false;

  late final StreamController<List<Job>> _streamController =
      StreamController.broadcast();

  late final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _source = widget.source;
    _streamController.stream.listen(
      _onData,
      onError: _onError,
    );

    _scrollController.addListener(_onScrollEnd);
    _scrollController.addListener(_onShowToTop);

    super.initState();
    _getJobs();
  }

  @override
  void dispose() {
    _streamController.close();
    _scrollController.removeListener(_onScrollEnd);
    _scrollController.removeListener(_onShowToTop);

    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        StreamBuilder<List<Job>>(
          stream: _streamController.stream,
          builder: _builder,
        ),
        Positioned(
          right: 16.0,
          bottom: 16.0,
          child: _ScrollToTop(
            onPressed: _scrollToTop,
            showScrollTop: _showScrollTop,
          ),
        ),
      ],
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
          Center(
            child: Column(
              children: [
                const Text('No Results Found'),
                RetryButton(
                  onRetryPressed: _onRetryPressed,
                ),
              ],
            ),
          ),
        );
      }

      child = ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 4.0),
        primary: widget.primary,
        itemBuilder: (context, index) => widgetList[index],
        itemCount: widgetList.length,
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: child,
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

  void _onShowToTop() {
    if (_scrollController.offset >= 100 && !_showScrollTop) {
      setState(() {
        _showScrollTop = true;
      });
    } else if (_scrollController.offset < 100 && _showScrollTop) {
      setState(() {
        _showScrollTop = false;
      });
    }
  }

  void _onData(List<Job> jobs) {
    _jobs.addAll(jobs);

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

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

class _ScrollToTop extends StatefulWidget {
  const _ScrollToTop({
    required this.onPressed,
    required this.showScrollTop,
  });

  final void Function() onPressed;
  final bool showScrollTop;

  @override
  State<_ScrollToTop> createState() => __ScrollToTopState();
}

class __ScrollToTopState extends State<_ScrollToTop> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.showScrollTop ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticIn,
      child: Visibility(
        visible: widget.showScrollTop,
        child: FloatingActionButton(
          onPressed: widget.onPressed,
          child: const Icon(Icons.arrow_upward),
        ),
      ),
    );
  }
}
