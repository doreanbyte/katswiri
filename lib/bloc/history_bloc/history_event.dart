part of 'history_bloc.dart';

/// [HistoryEvent] sealed class from where all other history events are derived from
sealed class HistoryEvent {
  const HistoryEvent();
}

/// [FetchHistory] an event that triggers the bloc to perform the search for jobs
/// and return a new state containing the jobs in the history table
final class FetchHistory extends HistoryEvent {
  const FetchHistory();
}

/// [ClearHistory] event triggers the deletion of viewed jobs from the history
/// table
final class ClearHistory extends HistoryEvent {
  const ClearHistory();
}

/// [AddToHistory] event that triggers an addition of the job into the history database
final class AddToHistory extends HistoryEvent {
  const AddToHistory(this.job);

  final Job job;
}
