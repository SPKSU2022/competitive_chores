import 'dart:async';

import 'package:competative_chores/Amplify.dart';
import 'package:competative_chores/Classes/Chores.dart';
import 'package:competative_chores/Classes/ScoreCards.dart';
import 'package:competative_chores/Classes/User.dart';
import 'package:competative_chores/Services/Database.dart';
import 'package:flutter/cupertino.dart';

class Initializer {
  static Future<void> initialize() async {
    await getFamilies();
    await Amp.isUserSignedIn().then((value) async {
      if (value) {
        await Amp.getCurrentUser().then((value) {});
      }
    });
  }

  static Future<void> getFamilyInfo() async {
    if (User.userAttributes.isNotEmpty) {
      await getChores(int.parse(User.userAttributes[0])).then((value) async {
        for (int i = 0; i < Chores.chores.length; i++) {
          if (Chores.chores[i][9] == null) {
            ScoreCards.totalPossibleScore = ScoreCards.totalPossibleScore + Chores.chores[i][4] as int;
          }
        }
        await getScorecards(int.parse(User.userAttributes[0])).then((value) async {
          List<String> cardNames = [];
          for (int i = 0; i < ScoreCards.scorecards.length; i++) {
            cardNames.add(ScoreCards.scorecards[i][2]);
            ScoreCards.totalAwardedScore = ScoreCards.totalAwardedScore + ScoreCards.scorecards[i][3] as int;
          }
          if (cardNames.contains(User.currentUser[0].toString())) {
            debugPrint('found user');
          } else {
            await insertScorecard(int.parse(User.userAttributes[0]));
          }
        });
      });
    } else {
      await initialize().then((value) async {
        await getChores(int.parse(User.userAttributes[0])).then((value) async {
          for (int i = 0; i < Chores.chores.length; i++) {
            if (Chores.chores[i][9] == null) {
              ScoreCards.totalPossibleScore = ScoreCards.totalPossibleScore + Chores.chores[i][4] as int;
            }
          }
          await getScorecards(int.parse(User.userAttributes[0])).then((value) async {
            List<String> cardNames = [];
            for (int i = 0; i < ScoreCards.scorecards.length; i++) {
              cardNames.add(ScoreCards.scorecards[i][2]);
              ScoreCards.totalAwardedScore = ScoreCards.totalAwardedScore + ScoreCards.scorecards[i][3] as int;
            }
            if (cardNames.contains(User.currentUser[0].toString())) {
              debugPrint('found user');
            } else {
              await insertScorecard(int.parse(User.userAttributes[0]));
            }
          });
        });
      });
    }
  }
}
