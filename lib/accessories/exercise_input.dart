import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        autofocus: true,
        inputFormatters: [ProperCaseTextFormatter()],
        decoration: const InputDecoration(labelText: "Exercise Name"),
      ),
      actions: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                      Flexible(child: Text("Add")),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.cancel_outlined),
                      Flexible(child: Text("Cancel")),
                    ],
                  ),
                ),
              ),
            ])
      ],
    );
  }
}

class ProperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) => newValue.copyWith(
      text: newValue.text
          .split(RegExp(r'\s+'))
          .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
          .join(' '));
}
