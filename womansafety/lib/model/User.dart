//@dart=2.9

import 'package:woman_safety/Utilities.dart';

class User {
  final String table = 'User';
  final String query =
      'CREATE TABLE User(id INT, name STRING, password STRING , address STRING, place STRING, background BOOLEAN )';

  var id;
  String name;
  String password;
  String place;
  String address;
  bool background;

  User({this.id, this.name, this.password, this.background,this.place,this.address});

  Map<String, dynamic> toMap(Map<String, dynamic> mp) {
    return {
      'id': mp['id'],
      'name': mp['name'],
      'password': mp['password'],
      'place': mp['place'],
      'address': mp['address'],
      'background': mp['background']
    };
  }

  User fromMap(Map mp) {}
//insertion
  connectDatabase(Map<String, dynamic> data) async {
    OurDatabase(table: this.table, query: this.query).insertTable(toMap(data));
  }
}

class Gurdians {
  final String table = 'Gurdians';
  final String query =
      'CREATE TABLE Gurdians(id INT, name STRING, phone STRING )';

  var id;
  String name;
  String phone;

  Gurdians({
    this.id,
    this.name,
    this.phone,
  });

  Map<String, dynamic> toMap(Map<String, dynamic> mp) {
    return {
      'id': mp['id'],
      'name': mp['name'],
      'phone': mp['phone'],
    };
  }

  Gurdians fromMap(Map mp) {}

  connectDatabase(Map<String, dynamic> data) async {
    OurDatabase(table: this.table, query: this.query).insertTable(toMap(data));
  }
}
