part of 'jobs_list_bloc.dart';

sealed class JobsListState {
  const JobsListState();
}

final class JobsListLoading extends JobsListState {
  const JobsListLoading({required this.jobs});

  final List<Job> jobs;
}

final class JobsListLoaded extends JobsListState {
  const JobsListLoaded({required this.jobs});

  final List<Job> jobs;
}

final class JobsListError extends JobsListState {
  const JobsListError({
    required this.jobs,
    required this.error,
  });

  final List<Job> jobs;
  final String error;
}
