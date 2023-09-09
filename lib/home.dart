import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:setlog/accessories/exercise_input.dart';
import 'package:setlog/view_exercise.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    retrieveExercises();
  }

  Map exercises = {};

  void retrieveExercises() async {
    Map retrievedExercises = {};
    final prefs = await SharedPreferences.getInstance();
    String? exercisesJson = "";
    try {
      exercisesJson = prefs.getString('exercises');
    } catch (e) {
      log("Error in loading getString $e");
    }
    if (exercisesJson != null) {
      final exercisesMap = jsonDecode(exercisesJson);
      retrievedExercises = Map<String, List<dynamic>>.from(exercisesMap);
    }
    setState(() {
      exercises = retrievedExercises;
    });
  }

  void storeExercises() async {
    final exercisesJson = jsonEncode(exercises);
    log("Storing data JSON Encoded: $exercisesJson");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('exercises', exercisesJson);
    log("Store data completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (content, index) {
                      final exerciseName = exercises.keys.elementAt(index);
                      return MaterialButton(
                        padding: const EdgeInsets.all(25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.fitness_center),
                                const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                                Text(exerciseName, textScaleFactor: 1.3),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    exercises.remove(exerciseName);
                                  });
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewExercise(
                                  onExerciseEdit: _handleExerciseEdit,
                                  exerciseName: exerciseName,
                                  exerciseData: exercises[exerciseName])));
                        },
                      );
                    }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => ExerciseInputDialog(
                    onExerciseAdded: _handleExerciseAdded,
                  ));
        },
        tooltip: 'Add Exercise',
        child: const Icon(Icons.playlist_add),
      ),
    );
  }

  void _handleExerciseAdded(String exerciseName) => setState(() {
        exercises[exerciseName] = [];
        storeExercises();
      });

  void _handleExerciseEdit(String exerciseName, List data) => setState(() {
        exercises[exerciseName] = data;
        storeExercises();
      });
}
