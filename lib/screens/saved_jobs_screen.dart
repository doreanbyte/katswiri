import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/repository/repository.dart';
import 'package:katswiri/sources/sources.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  static const route = '/saved_jobs';

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SavedJobsListRetriever(),
    );
  }
}

/// [SavedJobsListRetriever] retrieves the list of jobs that have been saved by
/// the user for later viewing.
class SavedJobsListRetriever extends StatefulWidget {
  const SavedJobsListRetriever({super.key});

  @override
  State<SavedJobsListRetriever> createState() => _SavedJobsListRetrieverState();
}

class _SavedJobsListRetrieverState extends State<SavedJobsListRetriever> {
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
    _getSaved();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
        widgetList.add(const Spinner());
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
            child: Text('No Recently Saved Jobs\nSwipe Down to Refresh List'),
          ),
        );
      }

      child = Center(
        child: ListView.builder(
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

  void _getSaved() async {
    try {
      final jobs = await SavedJobRepo.savedJobs();
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

    _getSaved();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _jobs.clear();
      _loading = true;
    });

    _getSaved();
  }
}
