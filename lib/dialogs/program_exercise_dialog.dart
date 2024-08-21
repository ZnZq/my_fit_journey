import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/dialogs/int_range_picker.dart';
import 'package:my_fit_journey/factories/program_exercise_factory.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/models/program.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';

class ProgramExerciseDialog extends StatefulWidget {
  final ProgramExercise programExercise;

  const ProgramExerciseDialog({super.key, required this.programExercise});

  @override
  State<ProgramExerciseDialog> createState() => _ProgramExerciseDialogState();
}

class _ProgramExerciseDialogState extends State<ProgramExerciseDialog> {
  int sets = 0;
  int reps = 0;
  int weight = 0;
  Duration restDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _loadExerciseInfo();
  }

  void _loadExerciseInfo() {
    if (widget.programExercise is ProgramMachineWeightExercise) {
      final machineExercise =
          widget.programExercise as ProgramMachineWeightExercise;
      sets = machineExercise.sets;
      reps = machineExercise.reps;
      weight = machineExercise.weight;
      restDuration = Duration(seconds: machineExercise.rest);
    }
    if (widget.programExercise is ProgramFreeWeightExercise) {
      final machineExercise =
          widget.programExercise as ProgramMachineWeightExercise;
      sets = machineExercise.sets;
      reps = machineExercise.reps;
      weight = machineExercise.weight;
      restDuration = Duration(seconds: machineExercise.rest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(globalPadding * 2),
              child: Column(
                children: [
                  Text(widget.programExercise.exercise!.title),
                  Text(
                    widget.programExercise.exercise!.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _buildExerciseInfo(context),
            const Divider(height: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(globalPadding * 2),
                child: Row(
                  children: [
                    Expanded(
                      child: SvgHighlight(
                        svgCode: maleFrontSvg,
                        highlightParts:
                            widget.programExercise.exercise?.bodyParts ?? [],
                      ),
                    ),
                    Expanded(
                      child: SvgHighlight(
                        svgCode: maleBackSvg,
                        highlightParts:
                            widget.programExercise.exercise?.bodyParts ?? [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(globalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('cancel'.i18n()),
                  ),
                  const SizedBox(width: globalPadding),
                  TextButton(
                    onPressed: () {
                      final programExercise = ProgramExerciseFactory.fromJson(
                          widget.programExercise.toJson());
                      if (programExercise is ProgramMachineWeightExercise) {
                        programExercise.sets = sets;
                        programExercise.reps = reps;
                        programExercise.weight = weight;
                        programExercise.rest = restDuration.inSeconds;
                      }

                      Navigator.of(context).pop(programExercise);
                    },
                    child: Text('save'.i18n()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightExerciseInfo(
      BuildContext context, WeightExercise exercise) {
    return Column(
      children: [
        ListTile(
          visualDensity: const VisualDensity(vertical: -3),
          title: Text('sets-reps'.i18n()),
          trailing: Text(
            '$sets ${'sets'.i18n()} x $reps ${'reps'.i18n()}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          onTap: () async {
            final options = await showDialog<List<IntRangePickerOption>?>(
              context: context,
              builder: (context) => IntRangePicker(
                title: 'select-sets-reps'.i18n(),
                options: [
                  IntRangePickerOption(
                    label: 'sets'.i18n(),
                    min: 1,
                    max: 100,
                    step: 1,
                    value: sets,
                    postfix: 'sets'.i18n(),
                  ),
                  IntRangePickerOption(
                    label: 'reps'.i18n(),
                    min: 1,
                    max: 100,
                    step: 1,
                    value: reps,
                    postfix: 'reps'.i18n(),
                  ),
                ],
              ),
            );

            if (!context.mounted || options == null) return;
            setState(() {
              sets = options[0].value;
              reps = options[1].value;
            });
          },
        ),
        Divider(height: 1, color: Colors.grey[300]),
        ListTile(
          visualDensity: const VisualDensity(vertical: -3),
          title: Text('weight'.i18n()),
          trailing: Text(
            '$weight ${exercise.weightUnit.name}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          onTap: () async {
            final options = await showDialog<List<IntRangePickerOption>?>(
              context: context,
              builder: (context) => IntRangePicker(
                options: [
                  IntRangePickerOption(
                    min: exercise.minWeight,
                    max: exercise.maxWeight,
                    step: exercise.weightStep,
                    postfix: exercise.weightUnit.name,
                  ),
                ],
                title: 'select-weight'.i18n(),
              ),
            );

            if (!context.mounted || options == null) return;
            setState(() {
              weight = options[0].value;
            });
          },
        ),
        Divider(height: 1, color: Colors.grey[300]),
        ListTile(
          visualDensity: const VisualDensity(vertical: -3),
          title: Text('rest'.i18n()),
          trailing: Text(
            restDuration.inMinutes > 0
                ? '${restDuration.inMinutes}m ${restDuration.inSeconds % 60}s'
                : '${restDuration.inSeconds}s',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          onTap: () async {
            final resultingDuration = await showDurationPicker(
              context: context,
              initialTime: restDuration,
              baseUnit: BaseUnit.second,
            );
            if (!context.mounted || resultingDuration == null) return;
            setState(() {
              restDuration = resultingDuration;
            });
          },
        ),
      ],
    );
  }

  Widget _buildExerciseInfo(BuildContext context) {
    final exercise = widget.programExercise.exercise!;
    if (exercise is WeightExercise) {
      return _buildWeightExerciseInfo(context, exercise);
    }

    return const SizedBox.shrink();
  }
}
