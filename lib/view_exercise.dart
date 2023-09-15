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
    final exerciseName = widget.exerciseName;
    final data = List<FlSpot>.generate(
      widget.exerciseData.length,
      (index) => FlSpot(index.toDouble(), widget.exerciseData[index][1][0].toDouble()),
    );
    final maxWeight = data.isNotEmpty ? data.map((spot) => spot.y).reduce(max) : 0;
    final showChart = widget.exerciseData.length > 1;

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
            if (showChart)
              AspectRatio(
                aspectRatio: 3,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    maxX: widget.exerciseData.length - 1,
                    maxY: maxWeight * 1.01,
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
                  int len = widget.exerciseData.length;
                  final exerciseEntry = widget.exerciseData[len - 1 - index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(DateFormat('d/M/y - hh:mm a').format(DateTime.parse(exerciseEntry[0]))),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.exerciseData.removeAt(len - 1 - index);
                                  widget.onExerciseEdit(widget.exerciseName, widget.exerciseData);
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

  void _handleRecordAdded(double weight, int reps) {
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
