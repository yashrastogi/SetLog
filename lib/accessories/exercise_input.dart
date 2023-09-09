import 'package:flutter/material.dart';

class ExerciseInputDialog extends StatefulWidget {
  const ExerciseInputDialog({super.key, required this.onExerciseAdded});
  final void Function(String exerciseName) onExerciseAdded;

  @override
  State<ExerciseInputDialog> createState() => _ExerciseInputDialogState();
}

class _ExerciseInputDialogState extends State<ExerciseInputDialog> {
  final TextEditingController _exerciseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Exercise"),
      content: TextField(
        controller: _exerciseController,
        decoration: const InputDecoration(labelText: "Exercise Name"),
      ),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                String exerciseName = _exerciseController.text;
                if (exerciseName.isNotEmpty) {
                  widget.onExerciseAdded(exerciseName);
                  Navigator.of(context).pop();
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.add_circle_outline),
                  Text("Add"),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Row(
                children: [
                  Icon(Icons.cancel_outlined),
                  Text("Cancel"),
                ],
              ),
            ),
          ),
        ])
      ],
    );
  }
}
