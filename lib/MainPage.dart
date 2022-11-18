import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:competative_chores/Amplify.dart';
import 'package:competative_chores/Classes/Chores.dart';
import 'package:competative_chores/Classes/Formatting.dart';
import 'package:competative_chores/Classes/User.dart';
import 'package:competative_chores/Screens/BackgroundAnimation.dart';
import 'package:competative_chores/Services/Database.dart';
import 'package:competative_chores/Widgets/ChoreList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getChores(int.parse(User.userAttributes[0])),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(children: [
              BackgroundAnimation(),
              Center(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Image.asset(
                                'assets/images/banner23.png',
                                fit: BoxFit.cover,
                                scale: .8,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                              child: Text(
                                User.userAttributes[1],
                                style: TextStyle(color: Formatting.creame, fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Formatting.bannerBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 7.5),
                        child: Text('Scoreboard'),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Formatting.bannerBlue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                height: MediaQuery.of(context).size.height / 2,
                                margin: const EdgeInsets.all(7.5),
                                child: ChoreList(),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Formatting.bannerBlue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                height: MediaQuery.of(context).size.height / 2,
                                margin: const EdgeInsets.all(7.5),
                                child: Text('Hello world'),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              )
            ]);
          } else {
            return Center(
              child: SpinKitSpinningLines(
                color: Formatting.bannerRed,
                size: 100,
                duration: const Duration(milliseconds: 1800),
              ),
            );
          }
        }));
  }
}
