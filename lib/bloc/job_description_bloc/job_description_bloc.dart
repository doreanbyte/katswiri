library job_description_bloc;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/repository/repository.dart';
import 'package:katswiri/sources/sources.dart';

part 'job_description_event.dart';
part 'job_description_state.dart';

final class JobDescriptionBloc
    extends Bloc<JobDescriptionEvent, JobDescriptionState> {
  JobDescriptionBloc() : super(const JobDescriptionInitial()) {
    on<FetchJobDescription>((event, emit) async {
      emit(const JobDescriptionLoading());
      if (event.job.description.isEmpty) {
        try {
          var job = await event.source.fetchJob(event.job.url);
          job = job.copyWith(
            url: event.job.url,
            logo: event.job.logo,
            position: event.job.position,
            posted: event.job.posted,
            tag: event.job.tag,
          );
          await JobHistoryRepo.saveHistory(job);
          emit(JobDescriptionLoaded(job));
        } catch (e) {
          emit(JobDescriptionError(e.toString()));
        }
      } else {
        await JobHistoryRepo.saveHistory(event.job);
        emit(JobDescriptionLoaded(event.job));
      }
    });
  }
}
