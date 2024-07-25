import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await init();
      return _db;
    } else {
      return _db;
    }
  }

  init() async {
    String datebasepath = await getDatabasesPath();
    String path = join(datebasepath, 'talaat.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "tasks"(
        "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
        "title" TEXT,
        "note" TEXT ,
        "date" STRING,
        "startTime" STRING,
        "endTime" STRING,
        "remind" INTEGER,
        "repeat" STRING,
        "color" INTEGER,
        "isCompleted" INTEGER
        
      )
''');
    print("CREATE DATABASE AND TABELS ============================");
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}

  readDate(String sql) async {
    Database? mydb = await db;
    var response = mydb!.rawQuery(sql);
    return response;
  }

  insertDate(String sql) async {
    Database? mydb = await db;
    var response = mydb!.rawInsert(sql);
    return response;
  }

  updateDate(String sql) async {
    Database? mydb = await db;
    var response = mydb!.rawUpdate(sql);
    return response;
  }

  deletetDate(String sql) async {
    Database? mydb = await db;
    var response = mydb!.rawDelete(sql);
    return response;
  }
  deletetAllDate(String sql) async {
    Database? mydb = await db;
    var response = mydb!.rawDelete(sql);
    return response;
  }
}
