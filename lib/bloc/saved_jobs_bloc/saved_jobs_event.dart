part of 'saved_jobs_bloc.dart';

/// [SavedJobsEvent] sealed class from where all other saved job events are
/// derived from
sealed class SavedJobsEvent {
  const SavedJobsEvent();
}

/// [FetchSavedJobs] an event that triggers the bloc to perform the search for jobs
/// and return a new state containing the jobs in the saved table
class FetchSavedJobs extends SavedJobsEvent {
  const FetchSavedJobs();
}

/// [DeleteSavedJobs] event triggers the deletion of saved jobs from the history
/// table
class DeleteSavedJobs extends SavedJobsEvent {
  const DeleteSavedJobs();
}
