import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

class DBManager {
  const DBManager._();

  static const _databaseName = 'katswiri.db';
  static const _databaseVersion = 1;

  static const instance = DBManager._();
  static final _lock = Lock();
  static Database? _database;

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE job (
        id INTEGER PRIMARY KEY,
        logo TEXT,
        position TEXT,
        company_name TEXT,
        location TEXT,
        type TEXT,
        posted INTEGER,
        url TEXT UNIQUE,
        description TEXT
      )
      ''',
    );

    await db.execute(
      '''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY,
        time_viewed INTEGER NOT NULL,
        job_id INTEGER UNIQUE,
        FOREIGN KEY (job_id) REFERENCES job (id) ON DELETE CASCADE
      )
      ''',
    );

    await db.execute(
      '''
      CREATE TABLE saved (
        id INTEGER PRIMARY KEY,
        time_saved INTEGER NOT NULL,
        job_id INTEGER UNIQUE,
        FOREIGN KEY (job_id) REFERENCES job (id) ON DELETE CASCADE
      )
      ''',
    );

    await db.execute(
      '''
      CREATE UNIQUE INDEX job_idx ON job (id, url)
      ''',
    );

    await db.execute(
      '''
      CREATE UNIQUE INDEX history_idx ON history (id, job_id)
      ''',
    );

    await db.execute(
      '''
      CREATE UNIQUE INDEX saved_idx ON saved (id, job_id)
      ''',
    );
  }

  FutureOr<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    await _lock.synchronized(() async {
      _database ??= await _initDatabase();
    });

    return _database!;
  }
}
