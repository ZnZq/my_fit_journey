// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({super.key});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class ExerciseStep {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final bool isShowContinueButton;

  ExerciseStep(
      {required this.title,
      required this.content,
      this.actions = const [],
      this.isShowContinueButton = true});
}

class _AddExercisePageState extends State<AddExercisePage> {
  final highlightParts = <BodyPart>[];
  final _formKey = GlobalKey<FormState>();
  late final Map<String, BodyGroup> bodyStructure;
  late final PageController _pageViewController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  int stepIndex = 0;
  late ExerciseType? exerciseTypeValue;
  Map<String, (dynamic, TextEditingController?)> specificationValues = {};

  @override
  void initState() {
    bodyStructure = getBodyStructure();
    _pageViewController = PageController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    setExerciseType(ExerciseType.machineWeight);

    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stepper(
                  currentStep: stepIndex,
                  onStepTapped: (value) => setState(() => stepIndex = value),
                  onStepCancel: () {
                    if (stepIndex > 0) {
                      setState(() {
                        stepIndex -= 1;
                      });
                    }
                  },
                  onStepContinue: () {
                    if (stepIndex <= 0) {
                      setState(() {
                        stepIndex += 1;
                      });
                    }
                  },
                  controlsBuilder: (context, details) {
                    return Row(
                      children: <Widget>[
                        ...steps[details.currentStep].actions,
                        if (steps[details.currentStep]
                            .isShowContinueButton) ...[
                          FilledButton(
                            onPressed: details.onStepContinue,
                            child: Text('next'.i18n()),
                          ),
                          SizedBox(width: globalPadding),
                        ],
                        if (stepIndex != 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: Text('back'.i18n()),
                          )
                      ],
                    );
                  },
                  steps: [
                    for (var step in steps)
                      Step(
                        isActive: true,
                        title: Text(step.title),
                        content: step.content,
                      ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.validate();
                  },
                  child: Text('save-exercise'.i18n()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<ExerciseStep> _getSteps() {
    return [
      ExerciseStep(
        title: 'exercise-details'.i18n(),
        content: _buildExerciseDetails(),
      ),
      ExerciseStep(
        title: 'target-muscles'.i18n(),
        actions: _buildRargetMusclesActions(),
        content: _buildRargetMuscles(),
      ),
      ExerciseStep(
        title: 'exercise-photos'.i18n(),
        content: _buildExercisePhotos(),
      ),
      ExerciseStep(
        title: 'exercise-specifications'.i18n(),
        isShowContinueButton: false,
        content: _buildExerciseSpecifications(),
      ),
    ];
  }

  List<Widget> _buildRargetMusclesActions() {
    return [
      FilledButton(
        onPressed: () async {
          var result = await Navigator.of(context)
              .pushNamed('/body-selector', arguments: highlightParts);
          if (result == null) {
            return;
          }

          setState(() {
            highlightParts.clear();
            highlightParts.addAll(result as List<BodyPart>);
          });
        },
        child: Text('choice'.i18n()),
      ),
      SizedBox(width: globalPadding),
    ];
  }

  Widget _buildExerciseSpecifications() {
    if (specificationValues.isEmpty) {
      return Text('No specifications for selected exercise type');
    }

    return Column(
      children: [
        for (var entry
            in exerciseTypeSpecifications[exerciseTypeValue]!.entries)
          entry.value.isEnum
              ? DropdownButtonFormField<dynamic>(
                  items: [
                    for (var option in entry.value.options!)
                      DropdownMenuItem(
                        value: option.$1,
                        child: Text(option.$2.i18n()),
                      )
                  ],
                  value: specificationValues[entry.key]!.$1,
                  onChanged: (value) {
                    specificationValues[entry.key] =
                        (value, specificationValues[entry.key]!.$2);
                  },
                )
              : TextField(
                  controller: specificationValues[entry.key]!.$2,
                  keyboardType: entry.value.inputType,
                  inputFormatters: entry.value.inputFormatters,
                  maxLines: null,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: entry.key,
                  ),
                ),
      ],
    );
  }

  Widget _buildExercisePhotos() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildPhotoCard(context),
          _buildPhotoCard(context),
          _buildPhotoCard(context),
          _buildPhotoCard(context),
          _buildPhotoCard(context),
        ],
      ),
    );
  }

  Widget _buildRargetMuscles() {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(globalPadding),
        child: Row(
          children: [
            Flexible(
              child: SvgHighlight(
                svgCode: maleFrontSvg,
                highlightParts: highlightParts.toList(),
              ),
            ),
            Flexible(
              child: SvgHighlight(
                svgCode: maleBackSvg,
                highlightParts: highlightParts.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _titleController,
          autofocus: false,
          decoration: InputDecoration(
            labelText: 'title'.i18n(),
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
        DropdownButtonFormField<ExerciseType>(
          decoration: InputDecoration(
            labelText: 'exercise-type'.i18n(),
          ),
          items: [
            for (var option in exerciseTypeOptions)
              DropdownMenuItem(
                value: option.$1,
                child: Text(option.$2.i18n()),
              )
          ],
          value: exerciseTypeValue,
          onChanged: _onExerciseTypeChanged,
          validator: (value) {
            if (value == null) {
              return 'Please select exercise type';
            }
            return null;
          },
        ),
        SizedBox(height: globalPadding * 2),
      ],
    );
  }

  void _onExerciseTypeChanged(ExerciseType? value) {
    setState(() {
      setExerciseType(value);
    });
  }

  void setExerciseType(ExerciseType? value) {
    exerciseTypeValue = value;
    if (exerciseTypeValue == null) {
      specificationValues.clear();
      return;
    }

    specificationValues =
        exerciseTypeSpecifications[exerciseTypeValue]!.map((key, value) {
      final dynamic v = value.initValueFn();
      return MapEntry(key, (
        v,
        value.isEnum
            ? null
            : (TextEditingController()
              ..value = TextEditingValue(text: v?.toString() ?? ''))
      ));
    });
  }

  Widget _buildPhotoCard(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 125,
        height: 125,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, size: 50),
            Text('add-photo'.i18n()),
          ],
        ),
      ),
    );
  }
}
