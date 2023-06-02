import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'comment_sqlite_model.dart';
import 'opportunity_sqlite_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'volunteer.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await OpportunitySQLiteModel.createTable(db);
        await CommentSQLiteModel.createTable(db);
      },
    );
  }
}
