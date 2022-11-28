import 'package:competative_chores/Amplify.dart';
import 'package:competative_chores/Classes/Formatting.dart';
import 'package:competative_chores/Classes/ScoreCards.dart';
import 'package:competative_chores/Classes/User.dart';
import 'package:competative_chores/Services/Database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Scoreboard extends StatefulWidget {
  const Scoreboard({Key? key}) : super(key: key);

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ScoreCards.scorecardNotifier,
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Formatting.bannerRed,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Formatting.lighterRed),
                ),
                child: ListView.builder(
                  itemCount: ScoreCards.scorecards.length,
                  itemBuilder: (context, index) {
                    double value = 0.0;
                    if (ScoreCards.scorecards[index][3] == 0) {
                      value = 0;
                    } else {
                      value = ScoreCards.scorecards[index][3] / ScoreCards.totalAwardedScore;
                    }

                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ScoreCards.scorecards[index][2],
                              style: TextStyle(color: Formatting.creame, fontWeight: FontWeight.bold),
                            ),
                          ),
                          LinearProgressIndicator(
                            color: Formatting.bannerBlue,
                            backgroundColor: Formatting.creame,
                            value: value,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Accumulated Points: ${ScoreCards.scorecards[index][3]}, Total Chores Completed: ${ScoreCards.scorecards[index][4]}',
                              style: TextStyle(color: Formatting.creame, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Formatting.bannerRed,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Formatting.lighterRed),
                ),
                child: Builder(
                  builder: (context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Current Standings',
                                    style: TextStyle(
                                      color: Formatting.creame,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Current Possible Points: ${ScoreCards.totalPossibleScore}',
                                      style: TextStyle(
                                        color: Formatting.creame,
                                        // decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Total Awarded Points: ${ScoreCards.totalAwardedScore}',
                                      style: TextStyle(
                                        color: Formatting.creame,
                                        // decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      '1st:',
                                      style: TextStyle(
                                        color: Formatting.creame,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: Builder(builder: (context) {
                                      int highest = 0;
                                      int points = 0;
                                      for (int i = 0; i < ScoreCards.scorecards.length; i++) {
                                        if (i == 0) {
                                          points = ScoreCards.scorecards[i][3];
                                          highest = i;
                                        } else if (points < ScoreCards.scorecards[i][3]) {
                                          points = ScoreCards.scorecards[i][3];
                                          highest = i;
                                        }
                                      }
                                      return Text(
                                        '${ScoreCards.scorecards[highest][2]} - ${ScoreCards.scorecards[highest][3]} Points!',
                                        style: TextStyle(
                                          color: Formatting.creame,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      '2nd:',
                                      style: TextStyle(
                                        color: Formatting.creame,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: Builder(builder: (context) {
                                      if (ScoreCards.scorecards.length < 2) {
                                        return Text(
                                          '*Empty*',
                                          style: TextStyle(
                                            color: Formatting.creame,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        );
                                      }
                                      int highest = 0;
                                      int second = 0;
                                      int points = 0;
                                      for (int i = 0; i < ScoreCards.scorecards.length; i++) {
                                        if (i == 0) {
                                          points = ScoreCards.scorecards[i][3];
                                          highest = i;
                                          second = i;
                                        } else if (points < ScoreCards.scorecards[i][3]) {
                                          points = ScoreCards.scorecards[i][3];
                                          second = highest;
                                          highest = i;
                                        }
                                      }
                                      return Text(
                                        '${ScoreCards.scorecards[second][2]} - ${ScoreCards.scorecards[second][3]} Points!',
                                        style: TextStyle(
                                          color: Formatting.creame,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      '3rd:',
                                      style: TextStyle(
                                        color: Formatting.creame,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: Builder(builder: (context) {
                                      if (ScoreCards.scorecards.length < 3) {
                                        return Text(
                                          '*Empty*',
                                          style: TextStyle(
                                            color: Formatting.creame,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        );
                                      }

                                      int highest = 0;
                                      int second = 0;
                                      int third = 0;
                                      int points = 0;
                                      for (int i = 0; i < ScoreCards.scorecards.length; i++) {
                                        if (i == 0) {
                                          points = ScoreCards.scorecards[i][3];
                                          highest = i;
                                          second = i;
                                          third = i;
                                        } else if (points < ScoreCards.scorecards[i][3]) {
                                          points = ScoreCards.scorecards[i][3];
                                          third = second;
                                          second = highest;
                                          highest = i;
                                        }

                                        if (i + 1 == ScoreCards.scorecards.length) {
                                          if ((third == second || third == highest) && ScoreCards.scorecards.length >= 3) {
                                            third = 0;
                                            while (third == second || third == highest) {
                                              third++;
                                            }
                                          }
                                        }
                                      }

                                      return Text(
                                        '${ScoreCards.scorecards[third][2]} - ${ScoreCards.scorecards[third][3]} Points!',
                                        style: TextStyle(
                                          color: Formatting.creame,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Most Chores Completed:',
                                      style: TextStyle(
                                        color: Formatting.creame,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: Builder(builder: (context) {
                                      int highest = 0;
                                      int chores = 0;
                                      for (int i = 0; i < ScoreCards.scorecards.length; i++) {
                                        if (i == 0) {
                                          chores = ScoreCards.scorecards[i][4];
                                          highest = i;
                                        } else if (chores < ScoreCards.scorecards[i][4]) {
                                          chores = ScoreCards.scorecards[i][4];
                                          highest = i;
                                        }
                                      }
                                      return Text(
                                        '${ScoreCards.scorecards[highest][2]} - ${ScoreCards.scorecards[highest][4]} Chores!',
                                        style: TextStyle(
                                          color: Formatting.creame,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Settings',
                                style: TextStyle(
                                  color: Formatting.creame,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Family #: ${User.userAttributes[0]}',
                                      style: TextStyle(
                                        color: Formatting.creame,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Amp.leaveFamily();
                                        },
                                        child: Text('Leave Family')),
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Family Name: "${User.userAttributes[1]}"',
                                    style: TextStyle(
                                      color: Formatting.creame,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Amp.signOutCurrentUser();
                                },
                                child: Text('Sign Out'),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ))
            ],
          );
        });
  }
}
