import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/bloc/bloc.dart';
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
/// ids in the history table. A [HistoryBloc] is used to listen to changes on
/// [HistoryState] and build the UI accordingly to the states emitted by the bloc
class HistoryListRetriever extends StatefulWidget {
  const HistoryListRetriever({super.key});

  @override
  State<HistoryListRetriever> createState() => _HistoryListRetrieverState();
}

class _HistoryListRetrieverState extends State<HistoryListRetriever> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryBloc, HistoryState>(
      listener: (context, historyState) {
        if (historyState is HistoryInitial) {
          _getHistory(context);
        }
      },
      builder: (context, historyState) {
        final Widget child;

        switch (historyState) {
          case HistoryLoaded(jobs: final jobs):
            final widgets = _buildWidgets(jobs);
            child = Center(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4.0),
                itemBuilder: (context, index) => widgets[index],
                itemCount: widgets.length,
              ),
            );
            break;
          case HistoryError(error: final error):
            child = Center(
              child: ErrorButton(
                errorMessage: error,
                onRetryPressed: () => _onRetryPressed(context),
              ),
            );
            break;
          default:
            child = const Center(
              child: CircularProgressIndicator(),
            );
            break;
        }

        return RefreshIndicator(
          backgroundColor: Colors.black,
          onRefresh: () async => _onRefresh(context),
          child: child,
        );
      },
    );
  }

  List<Widget> _buildWidgets(List<Job> jobs) {
    return switch (jobs.isNotEmpty) {
      true => jobs
          .map<Widget>((job) => JobTile(
                job: job,
                source: getSources().firstWhere(
                  (source) => job.url.contains(source.host),
                ),
              ))
          .toList(),
      false => [
          const Center(
            child: Text(
              'No Recently Viewed Jobs\nSwipe Down to Refresh List',
            ),
          ),
        ],
    };
  }

  void _getHistory(BuildContext context) {
    context.read<HistoryBloc>().add(const FetchHistory());
  }

  void _onRetryPressed(BuildContext context) => _getHistory(context);

  Future<void> _onRefresh(BuildContext context) async => _getHistory(context);
}
