import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:setlog/accessories/record_input.dart';

class ViewExercise extends StatefulWidget {
  const ViewExercise({super.key, required this.onExerciseEdit, required this.exerciseName, required this.exerciseData});
  final void Function(String exerciseName, List data) onExerciseEdit;
  final List exerciseData;
  final String exerciseName;

  @override
  State<ViewExercise> createState() => ViewExerciseState();
}

class ViewExerciseState extends State<ViewExercise> {
  @override
  Widget build(BuildContext context) {
    String exerciseName = widget.exerciseName;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => RecordInputDialog(
                    onRecordAdded: _handleRecordAdded,
                  ));
        },
        tooltip: 'Add record',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.

      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(exerciseName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: widget.exerciseData.length,
                    itemBuilder: (content, index) {
                      final exerciseEntry = widget.exerciseData[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(DateFormat('d/M/y').format(DateTime.parse(exerciseEntry[0]))),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.exerciseData.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                            subtitle: Text("${exerciseEntry[1][0]} kg\n${exerciseEntry[1][1]} reps"),
                          ),
                        ],
                      );
                    }))
          ],
        ),
      ),
    );
  }

  void _handleRecordAdded(int weight, int reps) {
    final DateTime now = DateTime.now();
    setState(() {
      widget.exerciseData.add([now.toString(), [weight, reps]]);
      widget.onExerciseEdit(widget.exerciseName, widget.exerciseData);
    });
  }
}
