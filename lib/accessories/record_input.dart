import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecordInputDialog extends StatefulWidget {
  const RecordInputDialog({super.key, required this.onRecordAdded});
  final void Function(double weight, int reps) onRecordAdded;

  @override
  State<RecordInputDialog> createState() => _RecordInputDialogState();
}

class _RecordInputDialogState extends State<RecordInputDialog> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Record"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [DecimalTextFormatter()],
            autofocus: true,
            decoration: const InputDecoration(labelText: "Enter Weight"),
          ),
          TextField(
            controller: _repsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: "Enter Reps"),
          ),
        ],
      ),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                double weight = double.parse(_weightController.text);
                int reps = int.parse(_repsController.text,);
                if (_weightController.text.isNotEmpty && _repsController.text.isNotEmpty) {
                  widget.onRecordAdded(weight, reps);
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

class DecimalTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any characters that are not digits or a single decimal point
    final filteredText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Ensure that there is only one decimal point
    final parts = filteredText.split('.');
    if (parts.length > 2) {
      return oldValue; // Reject the change if there are multiple decimal points
    }

    // Limit the number of decimal places to two
    if (parts.length == 2 && parts[1].length > 1) {
      return oldValue; // Reject the change if there are more than two decimal places
    }

    return newValue.copyWith(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}
