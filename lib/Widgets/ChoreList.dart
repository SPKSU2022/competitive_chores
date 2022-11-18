import 'package:competative_chores/Classes/Chores.dart';
import 'package:competative_chores/Classes/Formatting.dart';
import 'package:flutter/material.dart';

class ChoreList extends StatefulWidget {
  const ChoreList({Key? key}) : super(key: key);

  @override
  State<ChoreList> createState() => _ChoreListState();
}

class _ChoreListState extends State<ChoreList> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            child: ListView.builder(
              itemCount: Chores.chores.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: TextButton(
                      child: Text(
                        Chores.chores[index][2] + ' -- ' + Chores.chores[index][5] + ' -- ' + Chores.chores[index][4].toString(),
                        style: TextStyle(color: Formatting.creame),
                      ),
                      onPressed: () {},
                    ),
                  ),
                );
              },
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
}
