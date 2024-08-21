// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_fit_journey/const.dart';

class SelectWeightDialog extends StatefulWidget {
  final int startWeight;
  final int step;
  final int count;

  const SelectWeightDialog({
    super.key,
    this.startWeight = 0,
    this.step = 5,
    this.count = 10,
  });

  @override
  State<SelectWeightDialog> createState() => _SelectWeightDialogState();
}

class _SelectWeightDialogState extends State<SelectWeightDialog> {
  late final TextEditingController _startWeightController;
  late final TextEditingController _stepController;
  double count = 10;

  @override
  void initState() {
    _startWeightController = TextEditingController()
      ..value = TextEditingValue(text: widget.startWeight.toString());
    _stepController = TextEditingController()
      ..value = TextEditingValue(text: widget.step.toString());
    count = widget.count.toDouble();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: globalPadding,
          horizontal: globalPadding * 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: globalPadding),
            const Text('This is a typical dialog.'),
            const SizedBox(height: globalPadding),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: globalPadding),
              child: TextField(
                controller: _startWeightController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: false,
                decoration: InputDecoration(
                  labelText: 'start weight',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: globalPadding),
              child: TextField(
                controller: _stepController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: false,
                decoration: InputDecoration(
                  labelText: 'weight step',
                ),
              ),
            ),
            Row(
              children: [
                Text('Count: ${count.toStringAsFixed(0).padLeft(2, '0')}'),
                Expanded(
                  child: Slider(
                    value: count,
                    max: 20,
                    min: 1,
                    divisions: 20,
                    label: count.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        count = value;
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: const Text('Close'),
                ),
                TextButton(
                  onPressed: () {
                    var value = int.tryParse(_startWeightController.text);
                    Navigator.pop(context, value == null ? null : [value]);
                  },
                  child: const Text('Add weight'),
                ),
                TextButton(
                  onPressed: () {
                    var start = int.tryParse(_startWeightController.text);
                    var step = int.tryParse(_stepController.text);
                    if (start == null || step == null) {
                      Navigator.pop(context, null);
                      return;
                    }

                    var weights = <int>[];
                    for (var i = 0; i < count; i++) {
                      weights.add(start + i * step);
                    }

                    Navigator.pop(context, weights);
                  },
                  child: const Text('Add weights'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
