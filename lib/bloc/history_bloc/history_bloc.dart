library history_bloc;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/repository/repository.dart';

part 'history_event.dart';
part 'history_state.dart';

final class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const HistoryInitial()) {
    on<FetchHistory>((event, emit) async {
      try {
        emit(const HistoryLoading());
        final jobs = await JobHistoryRepo.viewedJobs();
        emit(HistoryLoaded(jobs));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<ClearHistory>((event, emit) async {
      try {
        emit(const HistoryLoading());
        await JobHistoryRepo.clearHistory();
        emit(const HistoryLoaded([]));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<AddToHistory>((event, emit) async {
      try {
        await JobHistoryRepo.saveHistory(event.job);
        final jobs = await JobHistoryRepo.viewedJobs();
        emit(HistoryLoaded(jobs));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });
  }
}
