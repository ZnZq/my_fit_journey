// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/dialogs/exercise_picker.dart';
import 'package:my_fit_journey/models/body_weight_exercise.dart';
import 'package:my_fit_journey/models/cardio_machine_exercise.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/models/free_weight_exercise.dart';
import 'package:my_fit_journey/models/machine_weight_exercise.dart';
import 'package:my_fit_journey/models/other_exercise.dart';
import 'package:my_fit_journey/models/swimming_exercise.dart';
import 'package:my_fit_journey/pages/exercise_page.dart';
import 'package:my_fit_journey/pages/extensions.dart';
import 'package:my_fit_journey/storage/storage.dart';
import 'package:my_fit_journey/widgets/exercise_card.dart';
import 'package:my_fit_journey/widgets/stack_app_bar_body.dart';
import 'package:my_fit_journey/widgets/stack_app_bar_button.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final Map<String, BodyGroup> bodyStructure = getBodyStructure();

  @override
  Widget build(BuildContext context) {
    return StackAppBarBody(
      title: 'exercises'.i18n(),
      body: Padding(
        padding: const EdgeInsets.only(left: kGap, right: kGap, bottom: kGap),
        child: ListenableBuilder(
          listenable: Storage.exerciseStorage,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.only(top: kGap * 2),
              child: ReorderableListView(
                clipBehavior: Clip.none,
                children: [
                  for (final exercise in Storage.exerciseStorage.items)
                    _buildExerciseCard(context, exercise),
                ],
                onReorder: (oldIndex, newIndex) {
                  Storage.exerciseStorage.moveTo(oldIndex, newIndex);
                },
              ),
            );
          },
        ),
      ),
      trailing: Row(
        children: [
          StackAppBarButton(
            child: IconButton(
              onPressed: () async {
                final exercise = await showDialog<Exercise?>(
                  context: context,
                  builder: (context) {
                    return const ExercisePicker();
                  },
                );

                if (exercise != null) {
                  _openExercise(exercise);
                }
              },
              icon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(width: kGap),
          StackAppBarButton(
            child: _buildAddExerciseButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAddExerciseButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final exercise = await showDialog<Exercise?>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: kBackgroundColor,
            title: Text(
              'add-exercise'.i18n(),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAddExerciseOption(
                  'machine-weight'.i18n(),
                  Icons.gavel_rounded,
                  ExerciseType.machineWeight.color,
                  MachineWeightExercise.empty(),
                  paddingTop: 0,
                ),
                _buildAddExerciseOption(
                  'free-weight'.i18n(),
                  Icons.rowing_rounded,
                  ExerciseType.freeWeight.color,
                  FreeWeightExercise.empty(),
                ),
                _buildAddExerciseOption(
                  'body-weight'.i18n(),
                  Icons.sports_gymnastics,
                  ExerciseType.bodyWeight.color,
                  BodyWeightExercise.empty(),
                ),
                _buildAddExerciseOption(
                  'cardio-machine'.i18n(),
                  Icons.monitor_heart_rounded,
                  ExerciseType.cardioMachine.color,
                  CardioMachineExercise.empty(),
                ),
                _buildAddExerciseOption(
                  'swimming'.i18n(),
                  Icons.pool_rounded,
                  ExerciseType.swimming.color,
                  SwimmingExercise.empty(),
                ),
                _buildAddExerciseOption(
                  'other'.i18n(),
                  Icons.pie_chart_outline_sharp,
                  ExerciseType.other.color,
                  OtherExercise.empty(),
                ),
              ],
            ),
          ),
        );

        if (exercise != null) {
          _openExercise(exercise);
        }
      },
      icon: const Icon(Icons.add),
    );
  }

  void _openExercise(Exercise exercise) {
    Navigator.of(context).pushNamed(ExercisePage.route, arguments: exercise);
  }

  Widget _buildAddExerciseOption(
    String text,
    IconData icon,
    Color color,
    Exercise exercise, {
    double paddingTop = kGap * 2,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Container(
        padding: const EdgeInsets.all(kGap),
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(kGap * 4),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kBackgroundColor.mix(kDarkShadowColor, .25),
              kBackgroundColor,
              kBackgroundColor,
              kBackgroundColor.mix(kLightShadowColor, .25),
            ],
            stops: const [0.0, .3, .7, 1.0],
          ),
          boxShadow: const [
            BoxShadow(
              color: kDarkShadowColor,
              offset: Offset(4, 4),
              spreadRadius: 1,
              blurRadius: 4,
            ),
            BoxShadow(
              color: kLightShadowColor,
              offset: Offset(-4, -4),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(kGap),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop(exercise);
            },
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: kGap),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    return ExerciseCard(
      key: Key(exercise.id.toString()),
      exercise: exercise,
      onTap: () => _openExercise(exercise),
      builder: (context, child) => Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              Padding(
                padding: const EdgeInsets.all(kGap * 2),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        key: Key(exercise.id.toString()),
        onDismissed: (direction) {
          Storage.exerciseStorage.remove(exercise.id);
        },
        child: child,
      ),
    );
  }
}
