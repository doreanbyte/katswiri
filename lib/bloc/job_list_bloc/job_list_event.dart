part of 'job_list_bloc.dart';

sealed class JobsListEvent {
  const JobsListEvent();
}

final class FetchJobs extends JobsListEvent {
  const FetchJobs({this.filter});

  final Map<String, String>? filter;
}

final class RefreshJobs extends JobsListEvent {
  const RefreshJobs({this.filter});

  final Map<String, String>? filter;
}
