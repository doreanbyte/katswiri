library job_save_bloc;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/repository/repository.dart';

part 'job_save_event.dart';
part 'job_save_state.dart';

class JobSaveBloc extends Bloc<JobSaveEvent, JobSaveState> {
  JobSaveBloc() : super(const JobSaveInitial()) {
    on<UnsaveJobEvent>((event, emit) async {
      await SavedJobRepo.clearJobFromSaved(event.job);
      emit(const JobIsSaved(false));
    });

    on<SaveJobEvent>((event, emit) async {
      await SavedJobRepo.saveJob(event.job);
      emit(const JobIsSaved(true));
    });

    on<CheckIsSavedEvent>((event, emit) async {
      final isSaved = await SavedJobRepo.isSaved(event.job);
      emit(JobIsSaved(isSaved));
    });
  }
}
