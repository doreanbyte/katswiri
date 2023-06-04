part of 'job_save_bloc.dart';

/// [JobSaveState] the derived class for other state classes to inherit from
sealed class JobSaveState {
  const JobSaveState();
}

/// [JobSaveInitial] the initial state of the status of the job being saved
class JobSaveInitial extends JobSaveState {
  const JobSaveInitial();
}

/// [JobIsSaved] state to keep track of whether the job is saved or unsaved
class JobIsSaved extends JobSaveState {
  const JobIsSaved(this.status);

  final bool status;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobIsSaved &&
          runtimeType == other.runtimeType &&
          status == other.status;

  @override
  int get hashCode => status.hashCode;
}

/// [JobSaveError] a failure state, likely a problem occurred while trying to
/// modify the database
class JobSaveError extends JobSaveState {
  const JobSaveError(this.error);

  final String error;
}
