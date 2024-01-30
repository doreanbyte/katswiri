part of 'job_description_bloc.dart';

sealed class JobDescriptionEvent {
  const JobDescriptionEvent();
}

final class FetchJobDescription extends JobDescriptionEvent {
  const FetchJobDescription({
    required this.job,
    required this.source,
  });

  final Job job;
  final Source source;
}
