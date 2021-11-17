//@dart=2.9
import 'package:sqflite/sqflite.dart' as checker;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class OurDatabase {
  String table;
  String query;

  OurDatabase({String table, String query}) {
    this.table = table;
    this.query = query;
  }

  Future<Database> database() async {
    Future<Database> database = openDatabase(
        path.join(await getDatabasesPath(), '$table.db'),
        version: 1, onCreate: (db, version) {
      db.execute(query);
    });
    return database;
  }

  Future<bool> databaseExists() async {
    return await checker
        .databaseExists(path.join(await getDatabasesPath(), '$table.db'));
  }

  insertTable(Map<String, dynamic> data) async {
    final Database db = await database();
    db.insert(table, data);
  }

  Future<dynamic> getTables() async {
    final Database db = await database();
    final tables = db.query(table);
    return tables;
  }

  Future<dynamic> getTable({String where, var whereArgs}) async {
    Database db = await database();
    return db.query(table, where: '$where=?', whereArgs: [whereArgs]);
  }

  delete(String key, List value) async {
    Database db = await database();
    db.delete(table, where: '$key=?', whereArgs: value);
  }

  Future<dynamic> updateTable(Map<String, dynamic> data) async {
    Database db = await database();
    await db.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  void deleteAll() async {
    Database db = await database();
    await db.delete(table);
  }
}
