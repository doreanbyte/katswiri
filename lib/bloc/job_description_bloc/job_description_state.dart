part of 'job_description_bloc.dart';

sealed class JobDescriptionState {
  const JobDescriptionState();
}

class JobDescriptionInitial extends JobDescriptionState {
  const JobDescriptionInitial();
}

class JobDescriptionLoading extends JobDescriptionState {
  const JobDescriptionLoading();
}

class JobDescriptionLoaded extends JobDescriptionState {
  const JobDescriptionLoaded(this.job);

  final Job job;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobDescriptionLoaded &&
          runtimeType == other.runtimeType &&
          job == other.job;

  @override
  int get hashCode => job.hashCode;
}

class JobDescriptionError extends JobDescriptionState {
  const JobDescriptionError(this.error);

  final String error;
}
