import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:setlog/accessories/record_input.dart';

class OneRMCalculatorScreen extends StatefulWidget {
  const OneRMCalculatorScreen({Key? key}) : super(key: key);

  @override
  _OneRMCalculatorScreenState createState() => _OneRMCalculatorScreenState();
}

class _OneRMCalculatorScreenState extends State<OneRMCalculatorScreen> {
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();

  var repMaxes = [];

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("1 RM Calculator"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              TextField(
                controller: _weightController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextFormatter()],
                onChanged: (value) {
                  calculateRepMaxes();
                },
                decoration: const InputDecoration(labelText: "Enter weight"),
              ),
              TextField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  calculateRepMaxes();
                },
                decoration: const InputDecoration(labelText: "Enter reps"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: repMaxes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text("${repMaxes[index][0]} RM: ${repMaxes[index][1].toStringAsFixed(2)} kg"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateRepMaxes() {
    final weight = double.tryParse(_weightController.text) ?? 0.0;
    final reps = int.tryParse(_repsController.text) ?? 0;

    if (weight > 0 && reps > 0) {
      repMaxes.clear();
      for (var i in [1, 2, 4, 6, 8, 10]) {
        repMaxes.add([i, oneRMCalculator(weight, reps, i)]);
      }
      setState(() {});
    }
  }

  double oneRMCalculator(double weight, int reps, int rm) {
    Map<int, double> weights = {
      1: 1,
      2: 0.95,
      4: 0.9,
      6: 0.85,
      8: 0.8,
      10: 0.75,
      12: 0.7,
      16: 0.65,
      20: 0.6,
      24: 0.55,
      30: 0.5
    };
    double? oneRM;
    if (weights.containsKey(reps)) {
      oneRM = weight / weights[reps]!;
    } else {
      int? lowerRepRange;
      int? higherRepRange;
      for (int i = reps; i < reps + 7; i++) {
        if (weights.containsKey(i)) {
          higherRepRange = i;
          break;
        }
      }
      for (int i = reps; i > reps - 7; i--) {
        if (weights.containsKey(i)) {
          lowerRepRange = i;
          break;
        }
      }
      if (reps > 30) {
        lowerRepRange = 30;
        higherRepRange = 30;
      }
      double maxAtLower = weight / weights[lowerRepRange]!;
      double maxAtHigher = weight / weights[higherRepRange]!;
      oneRM = (maxAtHigher + maxAtLower) / 2;
    }
    return oneRM * weights[rm]!;
  }
}
