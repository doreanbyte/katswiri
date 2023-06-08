part of 'save_job_bloc.dart';

/// [SaveJobState] the derived class for other state classes to inherit from
sealed class SaveJobState {
  const SaveJobState();
}

/// [SaveJobInitial] the initial state of the status of the job being saved
class SaveJobInitial extends SaveJobState {
  const SaveJobInitial();
}

/// [SavedJobsList] state to keep track of whether the job is saved or unsaved
class SavedJobsList extends SaveJobState {
  const SavedJobsList(this.jobs);

  final List<Job> jobs;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedJobsList &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(jobs, other.jobs);

  @override
  int get hashCode => const DeepCollectionEquality().hash(jobs);
}
