import 'package:flutter/material.dart';

class ScoreCards {
  static List<dynamic> scorecards = [];
  static ValueNotifier scorecardNotifier = ValueNotifier(scorecards);
  static int totalAwardedScore = 0;
  static int totalPossibleScore = 0;
}
