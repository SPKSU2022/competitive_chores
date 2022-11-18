import 'dart:async';

import 'package:competative_chores/Amplify.dart';
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
}
