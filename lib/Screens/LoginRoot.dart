// ignore_for_file: file_names
import 'package:competative_chores/Classes/Families.dart';
import 'package:competative_chores/Classes/Formatting.dart';
import 'package:competative_chores/Classes/User.dart';
import 'package:competative_chores/MainPage.dart';
import 'package:competative_chores/Screens/FamilyChecker.dart';
import 'package:competative_chores/Services/Initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginRoot extends StatefulWidget {
  const LoginRoot({Key? key}) : super(key: key);

  @override
  State<LoginRoot> createState() => _LoginRootState();
}

class _LoginRootState extends State<LoginRoot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Formatting.creame,
      body: Center(
        child: Builder(builder: (context) {
          return FutureBuilder(
            future: Initializer.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (User.userAttributes.isEmpty) {
                  return FamilyChecker();
                } else if (Families.allFamilyIDs.contains(int.parse(User.userAttributes[0]))) {
                  return const MainPage();
                } else {
                  return FamilyChecker();
                }
              } else {
                return Center(
                  child: SpinKitSpinningLines(
                    color: Formatting.bannerRed,
                    size: 100,
                    duration: const Duration(milliseconds: 1800),
                  ),
                );
              }
            },
          );
        }),
      ),
    );
  }
}
