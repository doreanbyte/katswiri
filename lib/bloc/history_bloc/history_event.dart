part of 'history_bloc.dart';

/// [HistoryEvent] sealed class from where all other history events are derived from
sealed class HistoryEvent {
  const HistoryEvent();
}

/// [HistoryFetch] an event that triggers the bloc to perform the search for jobs
/// and return a new state containing the jobs in the history table
class HistoryFetch extends HistoryEvent {
  const HistoryFetch();
}

/// [HistoryDelete] event triggers the deletion of viewed jobs from the history
/// table
class HistoryDelete extends HistoryEvent {
  const HistoryDelete();
}

/// [HistoryAdd] event that triggers an addition of the job into the history database
class HistoryAdd extends HistoryEvent {
  const HistoryAdd(this.job);

  final Job job;
}
