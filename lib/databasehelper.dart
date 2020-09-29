import 'dart:async';
import 'dart:io';


import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableUser = "favorite";
  final String columnId = "id";
  final String favId="favId";
  final String cat="cat";
  final String url="url";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentDirectory.path, "favorite.db"); //home://directory/files/maindb.db

    var ourDb = await openDatabase(path, version: 2, onCreate: _onCreate);
    return ourDb;
  }

  /*
     id | username | password
     ------------------------
     1  | Paulo    | paulo
     2  | James    | bond
   */

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY, $favId TEXT, $cat TEXT, $url TEXT)");}

  //CRUD - CREATE, READ, UPDATE , DELETE

  //Insertion
  Future<int> saveUser(String user,String url,String cat) async {
    var dbClient = await db;
    var map={
      "favId":user,
      "cat":cat,
      "url":url
    };
    int res = await dbClient.insert("$tableUser", map);
    return res;

  }

  //Get Users
  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser");

    return result.toList();
  }

  Future<int> getCount(String data) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableUser WHERE favId='$data'"));
  }

//  Future<User> getUser(int id) async {
//    var dbClient = await db;
//
//    var result = await dbClient.rawQuery("SELECT * FROM $tableUser WHERE $columnId = $id");
//    if (result.length == 0) return null;
//    return new User.fromMap(result.first);
//  }

  Future<int> deleteUser(String id) async {
    var dbClient = await db;

    return await dbClient.delete(tableUser,
        where: "$favId = ?", whereArgs: [id]);
  }


//  Future<int> updateUser(User user) async {
//    var dbClient = await db;
//    return await dbClient.update(tableUser,
//        user.toMap(), where: "$columnId = ?", whereArgs: [user.id]);
//  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }


}
