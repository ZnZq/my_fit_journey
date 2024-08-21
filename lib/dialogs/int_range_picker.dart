import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:numberpicker/numberpicker.dart';

class IntRangePickerOption {
  final String label;
  final String postfix;
  final int min;
  final int max;
  final int step;
  int value = 0;

  IntRangePickerOption({
    this.label = '',
    this.postfix = '',
    this.value = 0,
    required this.min,
    required this.max,
    required this.step,
  }) {
    if (value < min) {
      value = min;
    }
    if (value > max) {
      value = max;
    }
  }
}

class IntRangePicker extends StatefulWidget {
  final List<IntRangePickerOption> options;
  final String title;

  const IntRangePicker({super.key, required this.options, required this.title});

  @override
  State<IntRangePicker> createState() => _IntRangePickerState();
}

class _IntRangePickerState extends State<IntRangePicker> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('cancel'.i18n()),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(widget.options);
          },
          child: Text('ok'.i18n()),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              for (var option in widget.options) ...[
                if (option.label.isNotEmpty) Text(option.label),
                NumberPicker(
                  axis: Axis.horizontal,
                  textMapper: (value) => '$value ${option.postfix}',
                  minValue: option.min,
                  maxValue: option.max,
                  value: option.value,
                  step: option.step,
                  onChanged: (value) {
                    setState(() {
                      option.value = value;
                    });
                  },
                )
              ]
            ],
          ),
        ],
      ),
    );
  }
}
