import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bone/models/password_item.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database;


  String walletItemTable = 'wallet_item_table';
  String saltPepperTable = 'salt_pepper_table';
  String colSalt = 'salt';
  String colIV = 'initializaitonVector';
  String colId = 'id';
  String colLockerName = 'lockerName';
  String colUserName = 'userName';
  String colLockerType = 'lockerType';
  String colPassword = 'password';


  DatabaseHelper.createInstance();

  factory DatabaseHelper() {
    if(_databaseHelper==null) {
      _databaseHelper = DatabaseHelper.createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null) {
     _database = await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;

  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $walletItemTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colLockerName TEXT, '
    '$colUserName TEXT, $colPassword TEXT, $colLockerType INTEGER)');
    await db.execute('CREATE TABLE $saltPepperTable($colSalt BLOB, $colIV BLOB)' );
  }

  //Fetch
  Future<List<Map<String, dynamic>>> getPasswordItemMapList() async {
    Database db = await this.database;
    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colLockerType ASC');
    var result = await db.query(walletItemTable, orderBy: '$colLockerType ASC');
    return result;
  }
  //Insert
  Future<int> insertPasswordItem(PasswordItem note) async {
    Database db = await this.database;
    var result = await db.insert(walletItemTable, note.toMap());
    return result;
  }

  //Update
  Future<int> updatePasswordItem(PasswordItem note) async {
    Database db = await this.database;
    var result = await db.update(walletItemTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //Delete
  Future<int> deletePasswordItem(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $walletItemTable WHERE $colId = $id');
    return result;
  }
  //Get Number of objects
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $walletItemTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<PasswordItem>> getPasswordItemList() async {
    var noteMapList = await getPasswordItemMapList();
    int count = noteMapList.length;

    List<PasswordItem> noteList = List<PasswordItem>();

    for (int i=0; i<count; i++) {
      noteList.add(PasswordItem.fromMapObject(noteMapList[i]));
    }

    return noteList;

  }
}