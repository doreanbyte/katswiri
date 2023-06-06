import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/bloc/bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavedJobsBloc, SavedJobsState>(
      listener: (context, savedJobsState) {},
      builder: (context, savedJobsState) {
        final Widget child;

        switch (savedJobsState) {
          case SavedJobsLoaded(jobs: final jobs):
            final widgets = _buildWidgets(jobs);
            child = Center(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4.0),
                itemBuilder: (context, index) => widgets[index],
                itemCount: widgets.length,
              ),
            );
            break;
          case SavedJobsError(error: final error):
            child = Center(
              child: ErrorButton(
                errorMessage: error,
                onRetryPressed: () => _onRetryPressed(context),
              ),
            );
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
              'No Recently Saved Jobs\nSwipe Down to Refresh List',
              textAlign: TextAlign.center,
            ),
          ),
        ],
    };
  }

  void _getSavedJobs(BuildContext context) {
    context.read<SavedJobsBloc>().add(const FetchSavedJobs());
  }

  void _onRetryPressed(BuildContext context) => _getSavedJobs(context);

  Future<void> _onRefresh(BuildContext context) async => _getSavedJobs(context);
}
