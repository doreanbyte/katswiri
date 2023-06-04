part of 'saved_jobs_bloc.dart';

/// [SavedJobs] all subsclasses that have anything to do with the state of saved jobs
/// will inherit from here
sealed class SavedJobsState {
  const SavedJobsState();
}

/// [SavedJobsInitial] the initial state of the saved jobs state
class SavedJobsInitial extends SavedJobsState {
  const SavedJobsInitial();
}

/// [SavedJobsLoading] state to show that the jobs are in the process of being
/// loaded
class SavedJobsLoading extends SavedJobsState {
  const SavedJobsLoading();
}

class SavedJobsLoaded extends SavedJobsState {
  const SavedJobsLoaded(this.jobs);

  final List<Job> jobs;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedJobsLoaded &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(jobs, other.jobs);

  @override
  int get hashCode => const DeepCollectionEquality().hash(jobs);
}

/// [SavedJobsError] represents the error state for the states
class SavedJobsError extends SavedJobsState {
  const SavedJobsError();
}
