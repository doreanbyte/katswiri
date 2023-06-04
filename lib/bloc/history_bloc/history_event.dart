part of 'history_bloc.dart';

/// [HistoryEvent] sealed class from where all other history events are derived from
sealed class HistoryEvent {
  const HistoryEvent();
}

/// [FetchHistory] an event that triggers the bloc to perform the search for jobs
/// and return a new state containing the jobs in the history table
class FetchHistory extends HistoryEvent {
  const FetchHistory();
}

/// [DeleteHistory] event triggers the deletion of viewed jobs from the history
/// table
class DeleteHistory extends HistoryEvent {
  const DeleteHistory();
}

/// [AddHistory] event that triggers an addition of the job into the history database
class AddHistory extends HistoryEvent {
  const AddHistory(this.job);

  final Job job;
}
