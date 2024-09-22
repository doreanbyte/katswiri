library job_list_bloc;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/sources.dart';

part 'job_list_event.dart';
part 'job_list_state.dart';

final class JobsListBloc extends Bloc<JobsListEvent, JobsListState> {
  final List<Job> _jobs = [];
  final Source _source;
  int _page = 1;

  JobsListBloc({required Source source})
      : _source = source,
        super(const JobsListLoading(jobs: [])) {
    on<FetchJobs>((event, emit) async {
      try {
        emit(JobsListLoading(jobs: _jobs));
        final jobs = await _source.fetchJobs(
          page: _page,
          filter: event.filter,
        );

        _jobs.addAll(jobs);
        _page++;
        emit(JobsListLoaded(jobs: _jobs));
      } on Exception catch (e) {
        emit(JobsListError(jobs: _jobs, error: e.toString()));
      }
    });

    on<RefreshJobs>((event, emit) {
      try {} on Exception catch (e) {
        emit(JobsListError(jobs: _jobs, error: e.toString()));
      }
    });
  }
}
