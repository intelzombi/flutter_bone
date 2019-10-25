import 'package:flutter_bone/models/password_item.dart';
import 'package:flutter_bone/models/salt_pepper_item.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bone/models/wallet_item.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database;


  String walletItemTable = 'wallet_item_table';
  String saltPepperTable = 'salt_pepper_table';
  String passwordTable = 'password_table';
  String colSalt = 'salt';
  String colPepper = 'pepper';
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
    String path = directory.path + 'passwordWallet.db';
    var passwordWalletDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return passwordWalletDatabase;

  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $walletItemTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colLockerName TEXT, '
    '$colUserName TEXT, $colPassword TEXT, $colLockerType INTEGER)');
    await db.execute('CREATE TABLE $saltPepperTable($colId INTEGER PRIMARY KEY, $colSalt BLOB, $colPepper BLOB)' );
    await db.execute('CREATE TABLE $passwordTable($colId INTEGER PRIMARY KEY, $colPassword BLOB)');
  }

  //Fetch
  Future<List<Map<String, dynamic>>> getPasswordItemMapList() async {
    Database db = await this.database;
    int cnt = await getPasswordItemCount();
    if (cnt > 0) {
      var result = await db.rawQuery(
          'SELECT * FROM $passwordTable where $colId == 1');
      return result;
    }
    return new List<Map<String,dynamic>>();
  }

  //Fetch
  Future<List<Map<String, dynamic>>> getSaltPepperItemMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $saltPepperTable where $colId == 1');
    return result;
  }

  //Fetch
  Future<List<Map<String, dynamic>>> getWalletItemMapList() async {
    Database db = await this.database;
    //var result = await db.rawQuery('SELECT * FROM $walletItemTable order by $colLockerType ASC');
    var result = await db.query(walletItemTable, orderBy: '$colLockerType ASC');
    return result;
  }

  //Insert
  Future<int> insertSaltPepperItem(SaltPepperItem saltPepperItem) async{
    Database db = await this.database;
    var result = await db.insert(saltPepperTable, saltPepperItem.toMap());
    return result;
  }

  //Insert
  Future<int> insertWalletItem(WalletItem walletItem) async {
    Database db = await this.database;
    var result = await db.insert(walletItemTable, walletItem.toMap());
    return result;
  }

  //Insert
  Future<int> insertPasswordItem(PasswordItem passwordItem) async {
    Database db = await this.database;
    var result = await db.insert(passwordTable, passwordItem.toMap());
    return result;
  }

  //Update
  Future<int> updateSaltPepperItem(SaltPepperItem saltPepperItem) async {
    Database db = await this.database;
    //TODO Verify Where for columb id works correctly;
    var result = await db.update(saltPepperTable, saltPepperItem.toMap(), where: '$colId = 1');
    return result;
  }

  //Update
  Future<int> updateWalletItem(WalletItem walletItem) async {
    Database db = await this.database;
    var result = await db.update(walletItemTable, walletItem.toMap(), where: '$colId = ?', whereArgs: [walletItem.id]);
    return result;
  }

  //Update
  Future<int> updatePasswordItem(PasswordItem passwordItem) async {
    Database db = await this.database;
    var result = await db.update(passwordTable, passwordItem.toMap(), where: '$colId = 1');
    return result;
  }

  //Delete
  Future<int> deleteSaltPepperItem(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $saltPepperTable WHERE $colId = $id');
    return result;
  }

  //Delete
  Future<int> deleteWalletItem(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $walletItemTable WHERE $colId = $id');
    return result;
  }

  //Delete
  Future<int> deletePasswordItem(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $passwordTable WHERE $colId = $id');
    return result;
  }


  //Get Number of SaltPepperItems
  Future<int> getSaltPepperCount() async {
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $saltPepperTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Get Number of WalletItems
  Future<int> getWalletItemCount() async {
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $walletItemTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Get Number of SaltPepperItems
  Future<int> getPasswordItemCount() async {
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $passwordTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }


  Future<List<WalletItem>> getWalletItemList() async {
    var passwordItemMapList = await getWalletItemMapList();
    int count = passwordItemMapList.length;

    List<WalletItem> walletItemList = List<WalletItem>();

    for (int i=0; i<count; i++) {
      walletItemList.add(WalletItem.fromMapObject(passwordItemMapList[i]));
    }
    return walletItemList;
  }

  Future<List<SaltPepperItem>> getSaltPepperItemList() async {
    var saltPepperItemMapList = await getSaltPepperItemMapList();
    int count = saltPepperItemMapList.length;

    List<SaltPepperItem> saltPepperItemList = List<SaltPepperItem>();

    for (int i=0; i<count; i++) {
      saltPepperItemList.add(SaltPepperItem.fromMapObject(saltPepperItemMapList[i]));
    }
    return saltPepperItemList;
  }

  Future<List<PasswordItem>> getPasswordItemList() async {
    var passwordItemMapList = await getPasswordItemMapList();
    int count = passwordItemMapList.length;

    List<PasswordItem> passwordItemList = List<PasswordItem>();

    for (int i=0; i<count; i++) {
      passwordItemList.add(PasswordItem.fromMapObject(passwordItemMapList[i]));
    }
    return passwordItemList;
  }

}