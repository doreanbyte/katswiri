import 'package:katswiri/managers/managers.dart';
import 'package:katswiri/models/models.dart';
import 'package:sqflite/sqflite.dart';

const _jobTable = 'job';
const _historyTable = 'history';
const _savedTable = 'saved';

class JobHistoryRepo {
  const JobHistoryRepo._();

  /// Saves a job to the history table in the database. Checks if the job exists
  /// in the database and if not creates it and retrieves the id of the last insert
  /// item in the jobs table. This is then used in conjunction with the history table
  /// inserting the job id into it with the related history table columns. And in
  /// this case the viewed column of the history table is a DateTime timestamp
  static Future<void> saveHistory(Job job) async {
    final db = await DBManager.instance.database;
    final jobExists = await db.rawQuery(
      'SELECT id FROM $_jobTable WHERE url = ?',
      [job.url],
    );

    await db.transaction((txn) async {
      int jobId;

      if (jobExists.isEmpty) {
        final jobMap = job.toMap();
        jobId = await txn.insert(
          _jobTable,
          jobMap,
        );
      } else {
        jobId = jobExists.first['id'] as int;
      }

      await txn.insert(
        _historyTable,
        {
          'time_viewed': DateTime.now().millisecondsSinceEpoch,
          'job_id': jobId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  /// Retrieves a job from the history table in the database.
  static Future<Job> fromHistory(Job job) async {
    final db = await DBManager.instance.database;
    final viewedJob = await db.rawQuery(
      '''
      SELECT * FROM $_jobTable
      INNER JOIN $_historyTable
      ON $_jobTable.id = $_historyTable.job_id
      WHERE $_jobTable.url = ? LIMIT 1
      ''',
      [job.url],
    );

    if (viewedJob.isNotEmpty) {
      return Job.fromMap(viewedJob.first);
    }

    return Job.empty();
  }

  /// Retrieves a list of jobs that have been viewed by the user from the history
  /// table in the database and orders the retrieved jobs by the viewed
  static Future<List<Job>> viewedJobs() async {
    final db = await DBManager.instance.database;
    final viewedJobs = await db.rawQuery(
      '''
      SELECT * FROM $_jobTable
      INNER JOIN $_historyTable
      ON $_jobTable.id = $_historyTable.job_id
      ORDER BY $_historyTable.time_viewed DESC
      ''',
    );

    return viewedJobs.map((job) => Job.fromMap(job)).toList();
  }

  /// Removes a job from the history table in the database.
  static Future<void> clearJobFromHistory(Job job) async {
    final db = await DBManager.instance.database;

    await db.transaction(
      (txn) async => await txn.delete(
        _historyTable,
        where: 'job_id IN (SELECT id FROM $_jobTable WHERE url = ?)',
        whereArgs: [job.url],
      ),
    );
  }

  /// Clears all the jobs from the history table in the database.
  static Future<void> clearHistory() async {
    final db = await DBManager.instance.database;

    await db.transaction((txn) async => await txn.delete(_historyTable));
  }
}

class SavedJobRepo {
  const SavedJobRepo._();

  /// Saves a job to the saved table in the database. Before saving the job a check
  /// is made to see if the job is in the job table, if not it is created and then
  /// the id from it is used in the saved table, where the save_time column of the
  /// saved table is a timestamp
  static Future<void> saveJob(Job job) async {
    final db = await DBManager.instance.database;
    final jobMap = job.toMap();
    final jobExists = await db.rawQuery(
      'SELECT id, description FROM $_jobTable WHERE url = ?',
      [job.url],
    );

    await db.transaction(
      (txn) async {
        int jobId;

        if (jobExists.isEmpty) {
          jobId = await txn.insert(
            _jobTable,
            jobMap,
          );
        } else {
          jobId = jobExists.first['id'] as int;
          final description = jobExists.first['description'] as String;

          if (description.isEmpty && job.description.isNotEmpty) {
            await txn.insert(
              _jobTable,
              jobMap,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }

        await txn.insert(
          _savedTable,
          {
            'time_saved': DateTime.now().millisecondsSinceEpoch,
            'job_id': jobId,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      },
    );
  }

  /// Retrieves a job from the saved table in the database.
  static Future<Job> fromSaved(Job job) async {
    final db = await DBManager.instance.database;
    final savedJob = await db.rawQuery(
      '''
      SELECT * FROM $_jobTable
      INNER JOIN $_savedTable
      ON $_jobTable.id = $_savedTable.job_id
      WHERE $_jobTable.url = ? LIMIT 1
      ''',
      [job.url],
    );

    if (savedJob.isNotEmpty) {
      return Job.fromMap(savedJob.first);
    }

    return Job.empty();
  }

  /// Retrieves a list of jobs that have been saved by the user from the saved
  /// table in the database. Ordering the results by descending on the
  /// time_saved column
  static Future<List<Job>> savedJobs() async {
    final db = await DBManager.instance.database;
    final savedJobs = await db.rawQuery(
      '''
      SELECT * FROM $_jobTable
      INNER JOIN $_savedTable
      ON $_jobTable.id = $_savedTable.job_id
      ORDER BY $_savedTable.time_saved DESC
      ''',
    );

    return savedJobs.map((job) => Job.fromMap(job)).toList();
  }

  /// Removes a job from the saved table in the database.
  static Future<void> clearJobFromSaved(Job job) async {
    final db = await DBManager.instance.database;

    await db.transaction(
      (txn) async => await txn.delete(
        _savedTable,
        where: 'job_id IN (SELECT id FROM $_jobTable WHERE url = ?)',
        whereArgs: [job.url],
      ),
    );
  }

  /// Clears all the jobs from the saved table in the database.
  static Future<void> clearSaves() async {
    final db = await DBManager.instance.database;

    await db.transaction(
      (txn) async => await txn.delete(_savedTable),
    );
  }

  /// Checks if the given [job] can be found in the saved table and if so returns
  /// true otherwise returns false
  static Future<bool> isSaved(Job job) async {
    final db = await DBManager.instance.database;
    final savedJob = await db.rawQuery(
      '''
      SELECT * FROM $_jobTable
      INNER JOIN $_savedTable
      ON $_jobTable.id = $_savedTable.job_id
      WHERE $_jobTable.url = ? LIMIT 1
      ''',
      [job.url],
    );

    if (savedJob.isNotEmpty) {
      return true;
    }

    return false;
  }
}
