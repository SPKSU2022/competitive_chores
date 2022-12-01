import 'dart:async';

import 'package:competative_chores/Classes/Chores.dart';
import 'package:competative_chores/Classes/Formatting.dart';
import 'package:competative_chores/Classes/User.dart';
import 'package:competative_chores/Services/APICalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChoreCreator extends StatefulWidget {
  const ChoreCreator({Key? key}) : super(key: key);

  @override
  State<ChoreCreator> createState() => _ChoreCreatorState();
}

class _ChoreCreatorState extends State<ChoreCreator> {
  TextEditingController titleCreator = TextEditingController();
  TextEditingController descriptionCreator = TextEditingController();
  TextEditingController pointsCreator = TextEditingController();
  TextEditingController priorityCreator = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme(
                    brightness: Brightness.light,
                    primary: Formatting.lighterRed,
                    onPrimary: Color.fromARGB(255, 255, 212, 212),
                    secondary: Formatting.bannerBlue,
                    onSecondary: Colors.green,
                    error: Colors.blue,
                    onError: Colors.amber,
                    background: Colors.yellow,
                    onBackground: Colors.purple,
                    surface: Formatting.bannerBlue,
                    onSurface: Color.fromARGB(255, 190, 38, 58)),
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: Formatting.bannerRed,
                  floatingLabelStyle: TextStyle(color: Formatting.creame),
                  labelStyle: TextStyle(color: Formatting.creame.withAlpha(150)),
                  counterStyle: TextStyle(color: Formatting.textColor.withAlpha(150)),
                  errorStyle: const TextStyle(color: Colors.red),
                  hoverColor: Formatting.lighterRed.withAlpha(50),
                  iconColor: Formatting.lighterRed,
                  contentPadding: const EdgeInsets.all(16),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Formatting.lighterRed),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Formatting.lighterRed),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(style: BorderStyle.solid, color: Formatting.lighterRed),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: TextFormField(
                      controller: titleCreator,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: pointsCreator,
                      decoration: const InputDecoration(labelText: 'Points'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: TextFormField(
                      controller: priorityCreator,
                      decoration: const InputDecoration(labelText: 'Priority'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: TextField(
                        expands: true,
                        controller: descriptionCreator,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          helperMaxLines: 250,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 250,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Formatting.bannerRed),
                      ),
                      onPressed: () {
                        if (titleCreator.text.isEmpty || pointsCreator.text.isEmpty || priorityCreator.text.isEmpty || descriptionCreator.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Formatting.bannerRed,
                                title: Text(
                                  'Error!',
                                  style: TextStyle(color: Formatting.creame),
                                ),
                                content: Text('Please make sure every field is filled!'),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'OK',
                                                style: TextStyle(color: Formatting.creame),
                                              )),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        } else {
                          insertNewChore(int.parse(User.userAttributes[0]), titleCreator.text, int.parse(pointsCreator.text), priorityCreator.text,
                                  descriptionCreator.text)
                              .then((value) {
                            getAllChores(int.parse(User.userAttributes[0])).then((value) {
                              Timer(
                                Duration(milliseconds: 50),
                                () {
                                  setState(() {
                                    titleCreator.text = '';
                                    pointsCreator.text = '';
                                    priorityCreator.text = '';
                                    descriptionCreator.text = '';
                                    Chores.chores.sort(
                                      (a, b) {
                                        return b[4].compareTo(a[4]);
                                      },
                                    );
                                    Chores.choreNotifier.notifyListeners();
                                  });
                                },
                              );
                            });
                          });
                        }
                      },
                      child: Text(
                        'Create Chore',
                        style: TextStyle(color: Formatting.creame),
                      ))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
