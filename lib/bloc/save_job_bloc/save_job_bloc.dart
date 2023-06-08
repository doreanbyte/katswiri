library job_save_bloc;

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/repository/repository.dart';

part 'save_job_event.dart';
part 'save_job_state.dart';

class SaveJobBloc extends Bloc<JobSaveEvent, SaveJobState> {
  SaveJobBloc() : super(const SaveJobInitial()) {
    on<UnsaveJobEvent>((event, emit) async {
      try {
        await SavedJobRepo.clearJobFromSaved(event.job);
        final jobs = await SavedJobRepo.savedJobs();
        emit(SavedJobsList(jobs));
      } catch (e) {
        log(e.toString());
        emit(const SavedJobsList([]));
      }
    });

    on<SaveJobEvent>((event, emit) async {
      try {
        await SavedJobRepo.saveJob(event.job);
        final jobs = await SavedJobRepo.savedJobs();
        emit(SavedJobsList(jobs));
      } catch (e) {
        log(e.toString());
        emit(const SavedJobsList([]));
      }
    });

    on<CheckSavedJobs>((event, emit) async {
      try {
        final jobs = await SavedJobRepo.savedJobs();
        emit(SavedJobsList(jobs));
      } catch (e) {
        log(e.toString());
        emit(const SavedJobsList([]));
      }
    });
  }
}
