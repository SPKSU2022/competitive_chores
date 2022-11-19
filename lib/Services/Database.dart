import 'dart:convert';
import 'package:competative_chores/Classes/Chores.dart';
import 'package:competative_chores/Classes/Families.dart';
import 'package:competative_chores/Classes/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';

Future<void> getFamilies() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'competitivechores.c1qwrpxxowoh.us-east-1.rds.amazonaws.com',
    port: 3306,
    db: 'competitivechores',
    user: 'admin',
    password: '12345678',
  ));

  var result = await conn.query('Select* from family');
  List<dynamic> holder = result.toList();
  String lastJson = jsonEncode(holder);
  Families.allFamilies = jsonDecode(lastJson);
  for (final element in Families.allFamilies) {
    if (!Families.allFamilyNames.contains(element[1])) {
      Families.allFamilyNames.add(element[1]);
      Families.allFamilyIDs.add(element[0]);
    }
  }
  await conn.close();
}

Future<void> createFamily(String familyName) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'competitivechores.c1qwrpxxowoh.us-east-1.rds.amazonaws.com',
    port: 3306,
    db: 'competitivechores',
    user: 'admin',
    password: '12345678',
  ));

  await conn.query('insert into family(familyName) values (\'$familyName\');');
  await conn.close();
}

Future<void> getChores(int familyID) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'competitivechores.c1qwrpxxowoh.us-east-1.rds.amazonaws.com',
    port: 3306,
    db: 'competitivechores',
    user: 'admin',
    password: '12345678',
  ));

  var result = await conn.query('Select* from chores where familyID=$familyID');
  List<dynamic> holder = result.toList();
  String lastJson = jsonEncode(holder);
  Chores.chores = jsonDecode(lastJson);
  await conn.close();
}

Future<void> insertChore(int familyID, String title, int points, String priority, String description) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'competitivechores.c1qwrpxxowoh.us-east-1.rds.amazonaws.com',
    port: 3306,
    db: 'competitivechores',
    user: 'admin',
    password: '12345678',
  ));

  var now = DateTime.now();
  var formatter = DateFormat('MM-dd-yyyy');
  String dateAssigned = formatter.format(now);
  String assignedBy = User.currentUser[0];
  await conn.query(
      'insert into chores(familyID, title, description, points, priority, dateAssigned, assignedBy) values ($familyID, \'$title\', \'$description\', $points, \'$priority\', \'$dateAssigned\', \'$assignedBy\');');
  await conn.close();
}