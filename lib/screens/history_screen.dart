import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/repository/repository.dart';
import 'package:katswiri/sources/sources.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static const route = '/history';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: HistoryListRetriever(),
    );
  }
}

/// [HistoryListRetriever] retrieves the list of jobs that happen to have matching
/// ids in the history table. A [StreamBuilder] is used in conjunction with
/// [StreamController] listening to the stream and waiting for a list of [Job]
/// elements.
class HistoryListRetriever extends StatefulWidget {
  const HistoryListRetriever({super.key});

  @override
  State<HistoryListRetriever> createState() => _HistoryListRetrieverState();
}

class _HistoryListRetrieverState extends State<HistoryListRetriever> {
  late final StreamController<List<Job>> _streamController =
      StreamController.broadcast();
  final List<Job> _jobs = [];

  bool _loading = true;
  bool _hasError = false;
  String _errMsg = '';

  @override
  void initState() {
    _streamController.stream.listen(
      _onData,
      onError: _onError,
    );
    super.initState();
    _getHistory();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                source: getSources().firstWhere(
                  (source) => job.url.contains(source.host),
                ),
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
            child: Text('No Recently Viewed Jobs'),
          ),
        );
      }

      child = Center(
        child: ListView.builder(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
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

  void _getHistory() async {
    try {
      final jobs = await JobHistoryRepo.viewedJobs();
      _streamController.sink.add(jobs);
    } catch (e) {
      _streamController.addError(e);
    }
  }

  void _onData(List<Job> jobs) {
    _jobs.addAll(jobs);

    setState(() {
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

    _getHistory();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _jobs.clear();
      _loading = true;
    });

    _getHistory();
  }
}
