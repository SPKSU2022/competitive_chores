import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:competative_chores/Classes/Families.dart';
import 'package:competative_chores/Classes/Scorecards.dart';
import 'package:competative_chores/Classes/User.dart';
import 'package:flutter/cupertino.dart';

class Amp {
  static Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  static Future<AuthUser> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    await Amplify.Auth.fetchUserAttributes().then((value) {
      for (final element in value) {
        if (element.userAttributeKey.key == "name") {
          if (User.currentUser.contains(element.value)) {
          } else {
            User.currentUser.add(element.value);
          }
        } else if (element.userAttributeKey.key == "custom:familyid") {
          if (User.userAttributes.contains(element.value)) {
          } else {
            User.userAttributes.insert(0, element.value);
          }
        } else if (element.userAttributeKey.key == "custom:familyname") {
          if (User.userAttributes.contains(element.value)) {
          } else {
            User.userAttributes.add(element.value);
          }
        }
      }
    });

    debugPrint(User.currentUser.toString());
    debugPrint(User.userAttributes.toString());
    return user;
  }

  static Future<void> signOutCurrentUser() async {
    try {
      await Amplify.Auth.signOut();
      User.currentUser.clear();
      User.userAttributes.clear();
      ScoreCards.totalAwardedScore = 0;
      ScoreCards.totalPossibleScore = 0;
    } on AuthException catch (e) {
      print(e.message);
    }
  }
}


//Amplify.Auth.updateUserAttribute(userAttributeKey: CognitoUserAttributeKey.custom('name'), value: value)