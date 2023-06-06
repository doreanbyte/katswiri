library job_save_bloc;

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/repository/repository.dart';

part 'job_save_event.dart';
part 'job_save_state.dart';

class JobSaveBloc extends Bloc<JobSaveEvent, JobSaveState> {
  JobSaveBloc() : super(const JobSaveInitial()) {
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
