import 'dart:developer';
import 'package:flutter_sms_app/coniaste.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/sms_model.dart';

class DataBaseHelper {
  static final DataBaseHelper dbHelper = DataBaseHelper._();
  DataBaseHelper._();

  static Database? database;
  int? row;
  Future<Database> intiDataBase() async {
    if (database != null) return database!;
    database = await intiDb();
    return database!;
  }

  Future<Database> intiDb() async {
    String subPath = await getDatabasesPath();
    String path = join(subPath, 'Sms.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      log('Create DataBase');
      await db.execute(''' 
      CREATE TABLE $tableSms(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnRead INTEGER NOT NULL,
        $columnDate INTEGER NOT NULL,
        $columnDateSent INTEGER NOT NULL,
        $columnBody TEXT NOT NULL,
        $columnThreadId INTEGER NOT NULL
      )''');
    });
  }

  Future<List<SmsModel?>> getAllUser() async {
    Database database = await intiDataBase();
    List<Map<String, Object?>> maps = await database.query(tableSms);
    return maps.isNotEmpty
        ? maps.map((value) => SmsModel.fomJson(value)).toList()
        : [];
  }

  insertSms(SmsModel? smsModel) async {
    Database database = await intiDataBase();
    row = await database
        .insert(tableSms, smsModel!.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .whenComplete(() {
      log('OKKK ');
      log('row ${row}');
    });
  }

  deleteSms(String id) async {
    Database database = await intiDataBase();
    database.delete(tableSms, where: '$columnId =?', whereArgs: [id]);
  }

  // updateSms(SmsModel smsModel) async {
  //   var dbClient = await intiDataBase();
  //   smsModel.isComplete = !smsModel.isComplete;
  //   await dbClient.update(tableUser, smsModel.toMap(),
  //       where: '$columnId = ?', whereArgs: [user.id]);
  // }
}
