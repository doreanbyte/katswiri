part of 'job_save_bloc.dart';

/// [JobSaveState] the derived class for other state classes to inherit from
sealed class JobSaveState {
  const JobSaveState();
}

/// [JobSaveInitial] the initial state of the status of the job being saved
class JobSaveInitial extends JobSaveState {
  const JobSaveInitial();
}

/// [SavedJobsList] state to keep track of whether the job is saved or unsaved
class SavedJobsList extends JobSaveState {
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
