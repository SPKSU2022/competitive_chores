import 'dart:convert';
import 'package:competative_chores/Classes/Chores.dart';
import 'package:competative_chores/Classes/Families.dart';
import 'package:competative_chores/Classes/ScoreCards.dart';
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

Future<void> getScorecards(int familyID) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'competitivechores.c1qwrpxxowoh.us-east-1.rds.amazonaws.com',
    port: 3306,
    db: 'competitivechores',
    user: 'admin',
    password: '12345678',
  ));

  var result = await conn.query('Select* from scoreboard where familyID=$familyID');
  List<dynamic> holder = result.toList();
  String lastJson = jsonEncode(holder);
  ScoreCards.scorecards = jsonDecode(lastJson);
  await conn.close();
  ScoreCards.scorecardNotifier.notifyListeners();
}

Future<void> insertScorecard(int familyID) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'competitivechores.c1qwrpxxowoh.us-east-1.rds.amazonaws.com',
    port: 3306,
    db: 'competitivechores',
    user: 'admin',
    password: '12345678',
  ));

  String user = User.currentUser[0];
  debugPrint('${familyID}');
  await conn.query('insert into scoreboard(familyID, name, totalPoints, choresCompleted) values($familyID, \'$user\', 0, 0);');
  var result = await conn.query('Select* from scoreboard where familyID=$familyID');
  List<dynamic> holder = result.toList();
  String lastJson = jsonEncode(holder);
  ScoreCards.scorecards = jsonDecode(lastJson);
  ScoreCards.scorecards.sort(
    (a, b) {
      return a[3].compareTo(b[3]);
    },
  );
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

  ScoreCards.totalPossibleScore = ScoreCards.totalPossibleScore + points;
  var now = DateTime.now();
  var formatter = DateFormat('MM-dd-yyyy');
  String dateAssigned = formatter.format(now);
  String assignedBy = User.currentUser[0];
  await conn.query(
      'insert into chores(familyID, title, description, points, priority, dateAssigned, assignedBy) values ($familyID, \'$title\', \'$description\', $points, \'$priority\', \'$dateAssigned\', \'$assignedBy\');');
  await conn.close();
}

Future<void> completeChore(int choreID, int points) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'competitivechores.c1qwrpxxowoh.us-east-1.rds.amazonaws.com',
    port: 3306,
    db: 'competitivechores',
    user: 'admin',
    password: '12345678',
  ));
  var now = DateTime.now();
  var formatter = DateFormat('MM-dd-yyyy');
  String dateCompleted = formatter.format(now);
  String completedBy = User.currentUser[0];

  ScoreCards.totalAwardedScore = ScoreCards.totalAwardedScore + points;
  ScoreCards.totalPossibleScore = ScoreCards.totalPossibleScore - points;
  int newScore = 0;
  int choresTally = 0;
  int scoreCard = 0;
  for (int i = 0; i < ScoreCards.scorecards.length; i++) {
    if (ScoreCards.scorecards[i][2] == User.currentUser[0]) {
      newScore = ScoreCards.scorecards[i][3] + points;
      choresTally = ScoreCards.scorecards[i][4] + 1;
      scoreCard = ScoreCards.scorecards[i][0];
    }
  }

  await conn.query('update chores set dateCompleted=\'$dateCompleted\', completedBy=\'$completedBy\' where choreID=$choreID');
  await conn.query('update scoreboard set totalPoints=\'$newScore\', choresCompleted=\'$choresTally\' where scoreboardID=$scoreCard');
  await conn.close();
}
