import 'package:competative_chores/Classes/Chores.dart';
import 'package:competative_chores/Classes/Formatting.dart';
import 'package:flutter/material.dart';

class ChoreList extends StatefulWidget {
  const ChoreList({Key? key}) : super(key: key);

  @override
  State<ChoreList> createState() => _ChoreListState();
}

class _ChoreListState extends State<ChoreList> {
  bool sortPoints = true;
  bool sortAsc = true;
  int sortColumnIndex = 2;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              margin: EdgeInsets.all(5),
              child: DataTable(
                sortColumnIndex: 2,
                sortAscending: false,
                showCheckboxColumn: false,
                decoration: BoxDecoration(color: Formatting.bannerRed),
                columns: [
                  DataColumn(
                      label: Text(
                    'Title',
                    style: TextStyle(color: Formatting.creame),
                  )),
                  DataColumn(
                      label: Text(
                    'Priority',
                    style: TextStyle(color: Formatting.creame),
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
                        style: TextStyle(color: Formatting.creame),
                      )),
                ],
                rows: List.generate(Chores.chores.length, (index) => getData(Chores.chores, index)),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [Text('2')],
          ),
        )
      ],
    );
  }

  DataRow getData(List chores, index) {
    DataRow result = DataRow(
        cells: <DataCell>[
          DataCell(Text(Chores.chores[index][2], style: TextStyle(color: Formatting.creame))),
          DataCell(Text(Chores.chores[index][5], style: TextStyle(color: Formatting.creame))),
          DataCell(Text(Chores.chores[index][4].toString(), style: TextStyle(color: Formatting.creame))),
        ],
        color: MaterialStateColor.resolveWith((states) {
          return Formatting.bannerRed;
        }),
        onSelectChanged: (val) {
          debugPrint(index.toString());
        });

    return result;
  }
}
