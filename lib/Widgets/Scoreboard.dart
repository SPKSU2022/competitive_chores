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
                              'Accumulated Points: ${ScoreCards.scorecards[index][3]}',
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
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Current Standings:',
                                    style: TextStyle(color: Formatting.creame, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Amp.signOutCurrentUser();
                                  },
                                  child: Text('Sign Out'))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('Current Standings:'),
                              ElevatedButton(
                                  onPressed: () {
                                    Amp.signOutCurrentUser();
                                  },
                                  child: Text('Sign Out'))
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
