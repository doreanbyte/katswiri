import 'package:katswiri/db_manager.dart';
import 'package:katswiri/models/models.dart';
import 'package:sqflite/sqflite.dart';

class JobRepository {
  static const _jobTable = 'job';
  static const _historyTable = 'history';
  static const _savedTable = 'saved';

  // Saves a job to the history table in the database.
  static Future<void> saveHistory(Job job) async {}

  // Retrieves a job from the history table in the database.
  static Future<Job> fromHistory(Job job) async {
    return Job.empty();
  }

  // Retrieves a list of jobs that have been viewed by the user from the history table in the database.
  static Future<List<Job>> viewedJobs() async {
    return [Job.empty()];
  }

  // Removes a job from the history table in the database.
  static Future<void> clearJobFromHistory(Job job) async {}

  // Clears all the jobs from the history table in the database.
  static Future<void> clearHistory() async {}

  // Saves a job to the saved table in the database.
  static Future<void> saveJob(Job job) async {}

  // Retrieves a job from the saved table in the database.
  static Future<Job> fromSaves(Job job) async {
    return Job.empty();
  }

  // Retrieves a list of jobs that have been saved by the user from the saved table in the database.
  static Future<List<Job>> savedJobs() async {
    return [Job.empty()];
  }

  // Removes a job from the saved table in the database.
  static Future<void> clearJobFromSaved(Job job) async {}

  // Clears all the jobs from the saved table in the database.
  static Future<void> clearSaves() async {}
}
