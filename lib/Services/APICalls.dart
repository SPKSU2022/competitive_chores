import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:competative_chores/Classes/Chores.dart';
import 'package:competative_chores/Classes/Families.dart';
import 'package:competative_chores/Classes/Scorecards.dart';
import 'package:competative_chores/Classes/User.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<String> fetchAuthSession() async {
  String userToken = '';
  try {
    final result = await Amplify.Auth.fetchAuthSession();
    final identityId = (result as CognitoAuthSession).identityId!;
    final userToken = result.userPoolTokens!.idToken.raw;

    safePrint('identityId: $identityId');
    return userToken;
  } on AuthException catch (e) {
    safePrint(e.message);
  }
  return userToken;
}

Future<void> getAllFamilies() async {
  var url = Uri.parse('https://zt3r9w8en3.execute-api.us-east-1.amazonaws.com/Production/family');
  var response = await http.get(url);
  final parsed = jsonDecode(response.body)['body'];
  Families.allFamilies = jsonDecode(parsed);
  for (final element in Families.allFamilies) {
    if (!Families.allFamilyNames.contains(element[1])) {
      Families.allFamilyNames.add(element[1]);
      Families.allFamilyIDs.add(element[0]);
    }
  }
}

Future<void> getAllChores(int familyID) async {
  var url = Uri.parse('https://zt3r9w8en3.execute-api.us-east-1.amazonaws.com/Production/chores?familyID=$familyID');
  var response = await http.get(url);
  final parsed = jsonDecode(response.body);
  Chores.chores = parsed;
}

Future<void> getAllScorecards(int familyID) async {
  var url = Uri.parse('https://zt3r9w8en3.execute-api.us-east-1.amazonaws.com/Production/scoreboard?familyID=$familyID');
  var response = await http.get(url);
  final parsed = jsonDecode(response.body);
  ScoreCards.scorecards = parsed;
  ScoreCards.scorecardNotifier.notifyListeners();
}

Future<void> insertFamily(String familyName) async {
  var url = Uri.parse('https://zt3r9w8en3.execute-api.us-east-1.amazonaws.com/Production/family?familyName=$familyName');
  var response = await http.post(url);
}

Future<void> insertNewScorecard(int familyID) async {
  String user = User.currentUser[0];
  var url = Uri.parse('https://zt3r9w8en3.execute-api.us-east-1.amazonaws.com/Production/scoreboard?familyID=$familyID&name=$user');
  var response = await http.post(url).then((value) async {
    await getAllScorecards(familyID).then((value) {
      ScoreCards.scorecards.sort(
        (a, b) {
          return a[3].compareTo(b[3]);
        },
      );
    });
  });
}

Future<void> insertNewChore(int familyID, String title, int points, String priority, String description) async {
  ScoreCards.totalPossibleScore = ScoreCards.totalPossibleScore + points;
  var now = DateTime.now();
  var formatter = DateFormat('MM-dd-yyyy');
  String dateAssigned = formatter.format(now);
  String assignedBy = User.currentUser[0];

  var url = Uri.parse(
      'https://zt3r9w8en3.execute-api.us-east-1.amazonaws.com/Production/chores?familyID=$familyID&title=$title&points=$points&priority=$priority&description=$description&dateAssigned=$dateAssigned&assignedBy=$assignedBy');
  var response = await http.post(url);
  ScoreCards.scorecardNotifier.notifyListeners();
}

Future<void> updateChore(int choreID, int points) async {
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
  var url = Uri.parse(
      'https://zt3r9w8en3.execute-api.us-east-1.amazonaws.com/Production/chores?dateCompleted=$dateCompleted&completedBy=$completedBy&choreID=$choreID');
  var response = await http.put(url);
  url = Uri.parse(
      'https://zt3r9w8en3.execute-api.us-east-1.amazonaws.com/Production/scoreboard?totalPoints=$newScore&choresCompleted=$choresTally&scoreboardID=$scoreCard');
  response = await http.put(url);
}
