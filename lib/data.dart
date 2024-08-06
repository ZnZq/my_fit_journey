import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

enum BodyPartPosition {
  front,
  back,
}

const bodyPartPositionOptions = <(BodyPartPosition, String)>[
  (BodyPartPosition.front, 'body.front-side'),
  (BodyPartPosition.back, 'body.back-side'),
];

class BodyGroup {
  final String title;
  final Map<String, BodyPart> children;

  BodyGroup({
    required this.title,
    required this.children,
  });
}

class BodyPart extends Equatable {
  final String title;
  final String path;
  final BodyPartPosition position;

  const BodyPart({
    required this.title,
    required this.path,
    required this.position,
  });

  @override
  List<Object?> get props => [title, path, position];
}

Map<String, BodyGroup> getBodyStructure() {
  return {
    'arms': BodyGroup(
      title: 'body.arms',
      children: {
        'deltoideus': const BodyPart(
          title: 'body.deltoideus',
          path: '//g[@id="deltoideus"]/path',
          position: BodyPartPosition.front,
        ),
        'biceps': const BodyPart(
          title: 'body.biceps',
          path: '//g[@id="biceps"]/path',
          position: BodyPartPosition.front,
        ),
        'forearms': const BodyPart(
          title: 'body.forearms',
          path: '//g[@id="forearms"]/path',
          position: BodyPartPosition.front,
        ),
        'triceps': const BodyPart(
          title: 'body.triceps',
          path: '//g[@id="triceps"]/path',
          position: BodyPartPosition.back,
        ),
      },
    ),
    'torso': BodyGroup(
      title: 'body.torso',
      children: {
        'chest': const BodyPart(
          title: 'body.chest',
          path: '//g[@id="chest"]/path',
          position: BodyPartPosition.front,
        ),
        'side-abs': const BodyPart(
          title: 'body.side-abs',
          path: '//g[@id="side-abs"]/path',
          position: BodyPartPosition.front,
        ),
        'abs': const BodyPart(
          title: 'body.abs',
          path: '//g[@id="abs"]/path',
          position: BodyPartPosition.front,
        ),
        'upper-back': const BodyPart(
          title: 'body.upper-back',
          path: '//g[@id="upper-back"]/path',
          position: BodyPartPosition.back,
        ),
        'infraspinatus': const BodyPart(
          title: 'body.infraspinatus',
          path: '//g[@id="infraspinatus"]/path',
          position: BodyPartPosition.back,
        ),
        'middle-back': const BodyPart(
          title: 'body.middle-back',
          path: '//g[@id="middle-back"]/path',
          position: BodyPartPosition.back,
        ),
        'lower-back': const BodyPart(
          title: 'body.lower-back',
          path: '//g[@id="lower-back"]/path',
          position: BodyPartPosition.back,
        ),
      },
    ),
    'legs': BodyGroup(
      title: 'body.legs',
      children: {
        'quadriceps': const BodyPart(
          title: 'body.quadriceps',
          path: '//g[@id="quadriceps"]/path',
          position: BodyPartPosition.front,
        ),
        'tibialis': const BodyPart(
          title: 'body.tibialis',
          path: '//g[@id="tibialis"]/path',
          position: BodyPartPosition.front,
        ),
        'glutes': const BodyPart(
          title: 'body.glutes',
          path: '//g[@id="glutes"]/path',
          position: BodyPartPosition.back,
        ),
        'hamstrings': const BodyPart(
          title: 'body.hamstrings',
          path: '//g[@id="hamstrings"]/path',
          position: BodyPartPosition.back,
        ),
        'calves': const BodyPart(
          title: 'body.calves',
          path: '//g[@id="calves"]/path',
          position: BodyPartPosition.back,
        ),
      },
    ),
  };
}

late final String maleFrontSvg;
late final String maleBackSvg;

Future initData() async {
  maleFrontSvg = await rootBundle.loadString('assets/SVG/male_front.svg');
  maleBackSvg = await rootBundle.loadString('assets/SVG/male_back.svg');
}

enum ExerciseType {
  machineWeight,
  freeWeight,
  bodyweight,
  cardioMachine,
  stretching,
  swimming,
  other
}

const exerciseTypeOptions = <(ExerciseType, String)>[
  (ExerciseType.machineWeight, 'exercise-machine-weight'),
  (ExerciseType.freeWeight, 'exercise-free-weight'),
  (ExerciseType.bodyweight, 'exercise-body-weight'),
  (ExerciseType.cardioMachine, 'exercise-cardio-machine'),
  (ExerciseType.stretching, 'exercise-stretching'),
  (ExerciseType.swimming, 'exercise-swimming'),
  (ExerciseType.other, 'exercise-other'),
];

typedef ExerciseTypeSpecificationValueFn = dynamic Function();
typedef ToTextConverter = String Function(dynamic value);
typedef FromTextConverter<T> = T Function(String value);

class ExerciseTypeSpecification<T> {
  final ExerciseTypeSpecificationValueFn initValueFn;
  final FromTextConverter<T>? fromTextConverter;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEnum;
  final List<(T, String)>? options;

  ExerciseTypeSpecification({
    required this.initValueFn,
    this.fromTextConverter,
    this.inputType = TextInputType.text,
    this.inputFormatters = const [],
    this.isEnum = false,
    this.options = const [],
  });

  Type get type => T;
}

final exerciseTypeSpecifications =
    <ExerciseType, Map<String, ExerciseTypeSpecification>>{
  ExerciseType.machineWeight: {
    'weight-unit': ExerciseTypeSpecification<WeightUnit>(
      initValueFn: () => WeightUnit.kg,
      isEnum: true,
      options: weightUnitOptions,
    ),
    'min-weight': ExerciseTypeSpecification<double>(
      initValueFn: () => 5.0,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => double.parse(value),
    ),
    'max-weight': ExerciseTypeSpecification<double>(
      initValueFn: () => 150.0,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => double.parse(value),
    ),
    'weight-step': ExerciseTypeSpecification<double>(
      initValueFn: () => 5.0,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => double.parse(value),
    ),
  },
  ExerciseType.freeWeight: {
    'weight-unit': ExerciseTypeSpecification<WeightUnit>(
      initValueFn: () => WeightUnit.kg,
      isEnum: true,
      options: weightUnitOptions,
    ),
    'min-weight': ExerciseTypeSpecification<double>(
      initValueFn: () => 5.0,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => double.parse(value),
    ),
    'max-weight': ExerciseTypeSpecification<double>(
      initValueFn: () => 150.0,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => double.parse(value),
    ),
    'weight-step': ExerciseTypeSpecification<double>(
      initValueFn: () => 5.0,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => double.parse(value),
    ),
  },
  ExerciseType.bodyweight: {},
  ExerciseType.cardioMachine: {
    'min-speed': ExerciseTypeSpecification<double>(
      initValueFn: () => 1,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => double.parse(value),
    ),
    'max-speed': ExerciseTypeSpecification<double>(
      initValueFn: () => 10,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => double.parse(value),
    ),
    'speed-step': ExerciseTypeSpecification<double>(
      initValueFn: () => 1,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => double.parse(value),
    ),
    'min-intensity-level': ExerciseTypeSpecification<int>(
      initValueFn: () => 1,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => int.parse(value),
    ),
    'max-intensity-level': ExerciseTypeSpecification<int>(
      initValueFn: () => 10,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => int.parse(value),
    ),
    'intensity-level-step': ExerciseTypeSpecification<int>(
      initValueFn: () => 1,
      inputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      fromTextConverter: (value) => int.parse(value),
    ),
  },
  ExerciseType.stretching: {},
  ExerciseType.swimming: {},
  ExerciseType.other: {
    'details': ExerciseTypeSpecification<String>(
      initValueFn: () => '',
      inputType: TextInputType.multiline,
      fromTextConverter: (value) => value,
    ),
  },
};

class Exercise {
  final String title;
  final String description;
  final List<BodyPart> bodyParts;
  final ExerciseType type;

  Exercise({
    required this.title,
    required this.description,
    required this.bodyParts,
    required this.type,
  });
}

enum WeightUnit {
  kg,
  lb,
}

const weightUnitOptions = <(WeightUnit, String)>[
  (WeightUnit.kg, 'kg'),
  (WeightUnit.lb, 'lb'),
];
