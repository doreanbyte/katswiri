library job_list_bloc;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/sources.dart';

part 'jobs_list_event.dart';
part 'jobs_list_state.dart';

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
        final jobs = await _getJobs(filter: event.filter);

        _jobs.addAll(jobs);
        emit(JobsListLoaded(jobs: _jobs));
      } on Exception catch (e) {
        emit(JobsListError(
          jobs: _jobs,
          error: e.toString(),
        ));
      }
    });

    on<RefreshJobs>((event, emit) async {
      try {
        _jobs.clear();
        _page = 1;
        emit(JobsListLoading(jobs: _jobs));

        final jobs = await _getJobs(filter: event.filter);
        _jobs.addAll(jobs);
        emit(JobsListLoaded(jobs: _jobs));
      } on Exception catch (e) {
        emit(JobsListError(jobs: _jobs, error: e.toString()));
      }
    });
  }

  Future<List<Job>> _getJobs({Map<String, String>? filter}) async {
    final jobs = await _source.fetchJobs(
      page: _page,
      filter: filter,
    );
    _page++;

    return jobs;
  }
}
