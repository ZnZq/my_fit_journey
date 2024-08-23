import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/dialogs/program_exercise_dialog.dart';
import 'package:my_fit_journey/dialogs/exercise_picker.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/models/exercise_step.dart';
import 'package:my_fit_journey/models/program.dart';
import 'package:my_fit_journey/widgets/step_item.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';

class ProgramPage extends StatefulWidget {
  static const String route = '/program';
  final Program program;

  const ProgramPage({super.key, required this.program});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final List<ProgramExercise> exercises = [];

  @override
  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();

    loadProgramData();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void loadProgramData() {
    _nameController.text = widget.program.name;
    _descriptionController.text = widget.program.description;
  }

  void _onSave() {}

  List<ExerciseStep> _getSteps() {
    return [
      ExerciseStep(
        title: 'program-details'.i18n(),
        content: _buildProgramDetails(),
      ),
      ExerciseStep(
        title: 'exercises'.i18n(),
        actions: [_buildExercisesAddAction()],
        content: _buildExercises(),
      ),
    ];
  }

  Widget _buildExercisesAddAction() {
    return PopupMenuButton(
      icon: const Icon(Icons.add),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: _onAddProgramExercise,
          child: Text("exercise".i18n()),
        ),
        PopupMenuItem(
          onTap: _onAddComplexProgramExercise,
          child: Text("complex-exercise".i18n()),
        ),
      ],
    );
  }

  void _onAddComplexProgramExercise() {}

  void _onAddProgramExercise() async {
    final exercise = await showDialog<Exercise?>(
      context: context,
      builder: (context) {
        return const ExercisePicker();
      },
    );

    if (exercise == null) {
      return;
    }

    switch (exercise.type) {
      case ExerciseType.machineWeight:
        exercises.add(ProgramMachineWeightExercise(
            exerciseId: exercise.id,
            sets: 0,
            reps: 0,
            rest: 0,
            weight: 0,
            weightUnit: WeightUnit.kg));
        break;
      case ExerciseType.freeWeight:
        exercises.add(ProgramFreeWeightExercise(
            exerciseId: exercise.id,
            sets: 0,
            reps: 0,
            rest: 0,
            weight: 0,
            weightUnit: WeightUnit.kg));
        break;
      case ExerciseType.bodyWeight:
        exercises.add(ProgramBodyWeightExercise(exerciseId: exercise.id));
        break;
      case ExerciseType.cardioMachine:
        exercises.add(ProgramCardioMachineExercise(
          exerciseId: exercise.id,
          intensity: 0,
          speed: 0.0,
        ));
        break;
      case ExerciseType.swimming:
        exercises.add(ProgramSwimmingExercise(exerciseId: exercise.id));
        break;
      case ExerciseType.other:
        exercises.add(ProgramOtherExercise(exerciseId: exercise.id));
        break;
    }

    setState(() {});
  }

  Widget _buildExercises() {
    return Padding(
      padding: const EdgeInsets.only(left: kGap, right: kGap),
      child: ReorderableListView.builder(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        itemCount: exercises.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }

            final item = exercises.removeAt(oldIndex);
            exercises.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          if (exercise is ProgramComplexExercise) {
            return _buildComplexExercise(exercise);
          }

          return _buildExercise(exercise, index);
        },
      ),
    );
  }

  Widget _buildExercise(ProgramExercise programExercise, int index) {
    final exercise = programExercise.exercise;

    return Stack(
      clipBehavior: Clip.none,
      key: ValueKey(programExercise),
      children: [
        Card(
          clipBehavior: Clip.hardEdge,
          child: Dismissible(
            key: Key(programExercise.exercise!.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                exercises.removeAt(index);
              });
            },
            background: Container(
              color: Colors.red,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(kGap * 2),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            child: ListTile(
              onTap: () async {
                final exercise = await showDialog<ProgramExercise?>(
                  context: context,
                  builder: (context) {
                    return ProgramExerciseDialog(
                      programExercise: programExercise,
                    );
                  },
                );

                if (!context.mounted && exercise == null) {
                  return;
                }

                setState(() {
                  exercises[index] = exercise!;
                });
              },
              contentPadding: const EdgeInsets.only(
                left: kGap * 3,
                right: kGap,
              ),
              title: Text(exercise?.title ?? 'not found'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise?.description ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  _buildExerciseInfo(programExercise),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 32,
                    child: SvgHighlight(
                      svgCode: maleFrontSvg,
                      highlightParts: exercise?.bodyParts ?? [],
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    child: SvgHighlight(
                      svgCode: maleBackSvg,
                      highlightParts: exercise?.bodyParts ?? [],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: -kGap * 1.5,
          top: kGap * 3,
          child: CircleAvatar(
            radius: kGap * 2,
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseInfo(ProgramExercise programExercise) {
    if (programExercise is ProgramMachineWeightExercise) {
      return Text(
        '${programExercise.weight} ${programExercise.weightUnit.name}. ${programExercise.sets} ${'sets'.i18n()} x ${programExercise.reps} ${'reps'.i18n()}',
        style: const TextStyle(fontSize: 12),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildComplexExercise(ProgramComplexExercise programExercise) {
    return ListTile(
      key: ValueKey(programExercise),
      title: Text('complex-exercise'.i18n()),
    );
  }

  Widget _buildProgramDetails() {
    return Padding(
      padding: const EdgeInsets.only(right: kGap * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            autofocus: false,
            decoration: InputDecoration(
              labelText: 'name'.i18n(),
            ),
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter value';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            autofocus: false,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'description'.i18n(),
            ),
          ),
          const SizedBox(height: kGap * 2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();

    return Scaffold(
      appBar: AppBar(
        title: Text('program'.i18n()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSave,
        child: const Icon(Icons.save),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: kGap),
                for (var step in steps)
                  StepItem(
                    index: steps.indexOf(step) + 1,
                    title: Text(step.title),
                    actions: Row(children: step.actions),
                    child: step.content,
                  ),
                const SizedBox(height: kGap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
