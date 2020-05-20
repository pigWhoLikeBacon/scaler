import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:scaler/back/entity/base.dart';
import 'package:scaler/back/entity/day.dart';
import 'package:scaler/back/entity/day_plan.dart';
import 'package:scaler/back/entity/event.dart';
import 'package:scaler/back/entity/plan.dart';
import 'package:sqflite/sqflite.dart';

const String DATABASE_PATH = 'simple_todo.db';

abstract class DB {
  static Database _db;
  static final String path = DATABASE_PATH;
  static int get _version => 1;

  static _onCreate(Database db, int version) async {
    await db.execute('''
create table $tableDay (
  $Day_id integer primary key autoincrement,
  $Day_date text not null,
  $Day_log text not null)
''');

    await db.execute('''
create table $tableEvent (
  $Event_id integer primary key autoincrement,
  $Event_day_id integer not null,
  $Event_time text not null,
  $Event_content text not null)
''');

    await db.execute('''
create table $tablePlan ( 
  $Plan_id integer primary key autoincrement, 
  $Plan_content text not null)
''');

    await db.execute('''
create table $tableDayPlan (
  $DayPlan_id integer primary key autoincrement,
  $DayPlan_day_id integer not null,
  $DayPlan_plan_id integer not null,
  $DayPlan_isDone integer not null)
''');
  }

  static Future<void> init() async {
    if (_db == null) {
      try {
        _db = await openDatabase(path, version: _version, onCreate: _onCreate);
      } catch (e) {
        print(e);
      }
    }
    return _db;
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  /// return a map list.
  /// Please use the method "fromJson()" to convert it to an entity before use the result.
  static Future<Map<String, dynamic>> findById(String table, int id) async {
    List<Map> maps = await _db.query(table, where: 'id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return maps.first;
    }
    return null;
  }

  /// return map.
  /// Please use the method "fromJson()" to convert it to an entity before use the result.
  static Future<List<Map<String, dynamic>>> find(String table, String key, Object object) async {
    return await _db.query(table, where: key + ' = ?', whereArgs: [object]);
  }

  static Future<int> save(String table, Base base) async {
    if (base.id == null || await findById(table, base.id) == null) {
      return await _db.insert(table, base.toJson());
    } else {
      return await _db.update(table, base.toJson(), where: 'id = ?', whereArgs: [base.id]);
    }
  }

  static Future<int> deleteById(String table, int id) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [id]);

//  static Future<int> insert(String table, Base base) async =>
//      await _db.insert(table, base.toJson());
//
//  static Future<int> update(String table, Base base) async =>
//      await _db.update(table, base.toJson(), where: 'id = ?', whereArgs: [base.id]);
}

/// delete the db, create the folder and returnes its path
Future<String> initDeleteDb(String dbName) async {
  final databasePath = await getDatabasesPath();
  // print(databasePath);
  final path = join(databasePath, dbName);

  // make sure the folder exists
  if (await Directory(dirname(path)).exists()) {
    await deleteDatabase(path);
  } else {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      print(e);
    }
  }
  return path;
}

/// Check if a file is a valid database file
///
/// An empty file is a valid empty sqlite file
Future<bool> isDatabase(String path) async {
  Database db;
  bool isDatabase = false;
  try {
    db = await openReadOnlyDatabase(path);
    int version = await db.getVersion();
    if (version != null) {
      isDatabase = true;
    }
  } catch (_) {} finally {
    await db?.close();
  }
  return isDatabase;
}
