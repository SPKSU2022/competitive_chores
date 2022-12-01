import 'dart:async';

import 'package:competative_chores/Classes/Chores.dart';
import 'package:competative_chores/Classes/Formatting.dart';
import 'package:competative_chores/Classes/Scorecards.dart';
import 'package:competative_chores/Classes/User.dart';
import 'package:competative_chores/Services/APICalls.dart';
import 'package:flutter/material.dart';

class ChoreList extends StatefulWidget {
  const ChoreList({Key? key}) : super(key: key);

  @override
  State<ChoreList> createState() => _ChoreListState();
}

class _ChoreListState extends State<ChoreList> {
  bool sortPoints = true;
  bool sortAsc = true;
  int sortColumnIndex = 0;
  TextEditingController descriptionViewer = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: SingleChildScrollView(
                  child: DataTable(
                    sortColumnIndex: sortColumnIndex,
                    sortAscending: false,
                    showCheckboxColumn: false,
                    decoration: BoxDecoration(color: Formatting.bannerBlue),
                    columns: [
                      DataColumn(
                          label: Text(
                        'Title',
                        style: TextStyle(color: Formatting.creame, fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Priority',
                        style: TextStyle(color: Formatting.creame, fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          onSort: (columnIndex, _) {
                            setState(() {
                              sortColumnIndex = columnIndex;
                              if (sortAsc == true) {
                                sortAsc = false;
                                Chores.chores.sort((a, b) => a[4].compareTo(b[4]));
                              } else {
                                sortAsc = true;
                                Chores.chores.sort((a, b) => b[4].compareTo(a[4]));
                              }
                            });
                          },
                          label: Text(
                            'Points',
                            style: TextStyle(color: Formatting.creame, fontWeight: FontWeight.bold),
                          )),
                      DataColumn(
                          label: Text(
                        'Date Assigned',
                        style: TextStyle(color: Formatting.creame, fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                        label: Text(
                          'Status',
                          style: TextStyle(color: Formatting.creame, fontWeight: FontWeight.bold),
                        ),
                        onSort: (columnIndex, _) {
                          setState(() {
                            sortColumnIndex = columnIndex;
                            if (sortAsc == false) {
                              sortAsc = true;
                              Chores.chores.sort(
                                (a, b) {
                                  if (a[9] == null && b[9] == null) {
                                    return 0;
                                  } else if (a[9] == null && b[9] != null) {
                                    return -1;
                                  } else if (a[9] != null && b[9] == null) {
                                    return 1;
                                  } else {
                                    return 0;
                                  }
                                },
                              );
                            } else {
                              sortAsc = false;
                              Chores.chores.sort((a, b) {
                                if (b[9] == null && a[9] == null) {
                                  return 0;
                                } else if (b[9] == null && a[9] != null) {
                                  return -1;
                                } else if (b[9] != null && a[9] == null) {
                                  return 1;
                                } else {
                                  return 0;
                                }
                              });
                            }
                          });
                        },
                      ),
                    ],
                    rows: List.generate(Chores.chores.length, (index) => getData(Chores.chores, index)),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      valueListenable: Chores.choreNotifier,
    );
  }

  DataRow getData(List chores, index) {
    bool complete = true;
    if (Chores.chores[index][9] == null) {
      complete = false;
    }
    DataRow result = DataRow(
        cells: <DataCell>[
          DataCell(Text(Chores.chores[index][2], style: TextStyle(color: Formatting.creame))),
          DataCell(Text(Chores.chores[index][5], style: TextStyle(color: Formatting.creame))),
          DataCell(Text(Chores.chores[index][4].toString(), style: TextStyle(color: Formatting.creame))),
          DataCell(Text(Chores.chores[index][6].toString(), style: TextStyle(color: Formatting.creame))),
          DataCell(Text(complete.toString(), style: TextStyle(color: Formatting.creame))),
        ],
        color: MaterialStateColor.resolveWith((states) {
          return Formatting.bannerBlue;
        }),
        onSelectChanged: (val) {
          descriptionViewer.text = Chores.chores[index][3];
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  insetPadding: EdgeInsets.all(200),
                  backgroundColor: Formatting.bannerRed,
                  title: Text(
                    Chores.chores[index][2],
                    style: TextStyle(color: Formatting.creame),
                  ),
                  content: Column(children: [
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      readOnly: true,
                      controller: descriptionViewer,
                    ),
                  ]),
                  actions: [
                    Builder(builder: (context) {
                      if (complete == false) {
                        return Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: ElevatedButton(
                                  child: Text(
                                    'Complete',
                                    style: TextStyle(color: Formatting.creame),
                                  ),
                                  onPressed: () async {
                                    await updateChore(Chores.chores[index][0], Chores.chores[index][4]).then((value) async {
                                      await getAllChores(int.parse(User.userAttributes[0])).then((value) async {
                                        await getAllScorecards(int.parse(User.userAttributes[0])).then((value) {
                                          setState(() {});
                                          ScoreCards.scorecardNotifier.notifyListeners();
                                        });
                                      });
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Row(children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
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
                        ]);
                      }
                    })
                  ],
                );
              });
        });

    return result;
  }
}
