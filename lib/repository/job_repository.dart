import 'package:katswiri/db_manager.dart';
import 'package:katswiri/models/models.dart';
import 'package:sqflite/sqflite.dart';

class JobRepository {
  static const _jobTable = 'job';
  static const _historyTable = 'history';
  static const _savedTable = 'saved';

  static Future<void> saveHistory(Job job) async {}

  static Future<Job> fromHistory(Job job) async {
    return Job.empty();
  }

  static Future<List<Job>> viewedJobs() async {
    return [Job.empty()];
  }

  static Future<void> clearJobFromHistory(Job job) async {}

  static Future<void> clearHistory() async {}

  static Future<void> saveJob(Job job) async {}

  static Future<Job> fromSaves(Job job) async {
    return Job.empty();
  }

  static Future<List<Job>> savedJobs() async {
    return [Job.empty()];
  }

  static Future<void> clearJobFromSaved(Job job) async {}

  static Future<void> clearSaves() async {}
}
