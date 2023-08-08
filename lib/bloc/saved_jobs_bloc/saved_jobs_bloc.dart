library saved_jobs_bloc;

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/repository/repository.dart';

part 'saved_jobs_event.dart';
part 'saved_jobs_state.dart';

final class SavedJobsBloc extends Bloc<SavedJobsEvent, SavedJobsState> {
  SavedJobsBloc() : super(const SavedJobsInitial()) {
    on<FetchSavedJobs>((event, emit) async {
      try {
        emit(const SavedJobsLoading());
        final jobs = await SavedJobRepo.savedJobs();
        emit(SavedJobsLoaded(jobs));
      } catch (e) {
        emit(SavedJobsError(e.toString()));
      }
    });

    on<DeleteSavedJobs>((event, emit) async {
      try {
        emit(const SavedJobsLoading());
        await SavedJobRepo.clearSaves();
        emit(const SavedJobsLoaded([]));
      } catch (e) {
        emit(SavedJobsError(e.toString()));
      }
    });
  }
}
