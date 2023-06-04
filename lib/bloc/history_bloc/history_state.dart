part of 'history_bloc.dart';

/// [HistoryState] the derived state from which other History state classes extends
/// from
sealed class HistoryState {
  const HistoryState();
}

/// [HistoryInitial] the initial state of history
class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

/// [HistoryLoading] is the state that representst the history list being loaded
class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

/// [HistoryLoaded] is the state that represents retrieval of value from history
/// repository
class HistoryLoaded extends HistoryState {
  const HistoryLoaded(this.jobs);

  final List<Job> jobs;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryLoaded &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(jobs, other.jobs);

  @override
  int get hashCode => const DeepCollectionEquality().hash(jobs);
}

/// [HistoryError] is the state of failure from trying to load the history list
class HistoryError extends HistoryState {
  const HistoryError(this.error);

  final String error;
}
