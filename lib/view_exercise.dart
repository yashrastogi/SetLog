import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

    // Sample data for the chart
    List<FlSpot> data = [];
    int maxWeight = 0;
    int minWeight = 0;
    for (int i = 0; i < widget.exerciseData.length; i++) {
      data.add(FlSpot(i + 0.0, widget.exerciseData[i][1][0] + 0.0));
      maxWeight = max(maxWeight, widget.exerciseData[i][1][0]);
      minWeight = min(minWeight, widget.exerciseData[i][1][0]);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => RecordInputDialog(
                    onRecordAdded: _handleRecordAdded,
                  ));
        },
        tooltip: 'Add Record',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(exerciseName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 5,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  minX: minWeight + 0.0,
                  maxX: widget.exerciseData.length - 1.0,
                  minY: 0,
                  maxY: maxWeight * 1.7,
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.exerciseData.length,
                itemBuilder: (context, index) {
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
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                        subtitle: Text("${exerciseEntry[1][0]} kg\n${exerciseEntry[1][1]} reps"),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRecordAdded(int weight, int reps) {
    final DateTime now = DateTime.now();
    setState(() {
      widget.exerciseData.add([
        now.toString(),
        [weight, reps]
      ]);
      widget.onExerciseEdit(widget.exerciseName, widget.exerciseData);
    });
  }
}
