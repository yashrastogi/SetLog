import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Map exercises = {};
  bool _showFab = true;
  bool _isFABHeld = false;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.forward) {
        setState(() {
          _showFab = true;
        });
      } else if (controller.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {
          _showFab = false;
        });
      }
    });

    if (controller.hasClients) {
      double totalHeight = controller.position.maxScrollExtent;
      double viewportHeight = controller.position.viewportDimension;
      if (totalHeight >= viewportHeight) {
        // list is scrollable
        setState(() {
          _showFab = true;
        });
      }
    }
    retrieveExercises();
  }

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
                    controller: controller,
                    itemCount: exercises.length,
                    itemBuilder: (content, index) {
                      final exerciseName = exercises.keys.elementAt(index);
                      return MaterialButton(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.fitness_center),
                                const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                                Text(truncateText(exerciseName, 27), textScaleFactor: 1.2),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    exercises.remove(exerciseName);
                                    storeExercises();
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
      floatingActionButton: _showFab
          ? GestureDetector(
              onLongPress: () {
                Future.delayed(const Duration(seconds: 3), () {
                  if (_isFABHeld) {
                    Clipboard.setData(ClipboardData(text: jsonEncode(exercises)));
                    Fluttertoast.showToast(msg: "Copied JSON to clipboard");
                  }
                });
                setState(() {
                  _isFABHeld = true;
                });
              },
              onLongPressEnd: (details) {
                setState(() {
                  _isFABHeld = false;
                });
              },
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => ExerciseInputDialog(
                            onExerciseAdded: _handleExerciseAdded,
                          ));
                },
                child: const Icon(Icons.playlist_add),
              ),
            )
          : null,
    );
  }

  void _handleExerciseAdded(String exerciseName) => setState(() {
        exerciseName = exerciseName.trim();
        if (!exercises.containsKey(exerciseName)) {
          exercises[exerciseName] = [];
          storeExercises();
        }
      });

  void _handleExerciseEdit(String exerciseName, List data) => setState(() {
        exercises[exerciseName] = data;
        storeExercises();
      });
}

String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }
  return '${text.substring(0, maxLength)}...';
}
