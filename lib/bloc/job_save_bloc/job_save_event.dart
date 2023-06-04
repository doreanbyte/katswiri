part of 'job_save_bloc.dart';

/// [JobSaveEvent] sealed class from which other SaveJobEvent subsclasses will
/// inherit from
sealed class JobSaveEvent {
  const JobSaveEvent();
}

/// [UnsaveJobEvent] triggers the bloc to handle removal of the [Job] from the saved
/// jobs table
class UnsaveJobEvent extends JobSaveEvent {
  const UnsaveJobEvent(this.job);

  final Job job;
}

/// [SaveJobEvent] triggers an event on the bloc to save the specified [Job] to
/// the saved jobs database
class SaveJobEvent extends JobSaveEvent {
  const SaveJobEvent(this.job);

  final Job job;
}

/// [CheckIsSavedEvent] triggers an event that makes the bloc return the state of
/// whether a job is saved or not.
class CheckIsSavedEvent extends JobSaveEvent {
  const CheckIsSavedEvent(this.job);

  final Job job;
}
