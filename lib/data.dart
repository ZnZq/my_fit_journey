import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/models/body_part.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

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

Map<String, BodyGroup> getBodyStructure() {
  return {
    'arms': BodyGroup(
      title: 'body.arms',
      children: {
        'deltoideus': BodyPart(
          title: 'body.deltoideus',
          path: '//g[@id="deltoideus"]/path',
          position: BodyPartPosition.front,
        ),
        'biceps': BodyPart(
          title: 'body.biceps',
          path: '//g[@id="biceps"]/path',
          position: BodyPartPosition.front,
        ),
        'forearms': BodyPart(
          title: 'body.forearms',
          path: '//g[@id="forearms"]/path',
          position: BodyPartPosition.front,
        ),
        'triceps': BodyPart(
          title: 'body.triceps',
          path: '//g[@id="triceps"]/path',
          position: BodyPartPosition.back,
        ),
      },
    ),
    'torso': BodyGroup(
      title: 'body.torso',
      children: {
        'chest': BodyPart(
          title: 'body.chest',
          path: '//g[@id="chest"]/path',
          position: BodyPartPosition.front,
        ),
        'side-abs': BodyPart(
          title: 'body.side-abs',
          path: '//g[@id="side-abs"]/path',
          position: BodyPartPosition.front,
        ),
        'abs': BodyPart(
          title: 'body.abs',
          path: '//g[@id="abs"]/path',
          position: BodyPartPosition.front,
        ),
        'upper-back': BodyPart(
          title: 'body.upper-back',
          path: '//g[@id="upper-back"]/path',
          position: BodyPartPosition.back,
        ),
        'infraspinatus': BodyPart(
          title: 'body.infraspinatus',
          path: '//g[@id="infraspinatus"]/path',
          position: BodyPartPosition.back,
        ),
        'middle-back': BodyPart(
          title: 'body.middle-back',
          path: '//g[@id="middle-back"]/path',
          position: BodyPartPosition.back,
        ),
        'lower-back': BodyPart(
          title: 'body.lower-back',
          path: '//g[@id="lower-back"]/path',
          position: BodyPartPosition.back,
        ),
      },
    ),
    'legs': BodyGroup(
      title: 'body.legs',
      children: {
        'quadriceps': BodyPart(
          title: 'body.quadriceps',
          path: '//g[@id="quadriceps"]/path',
          position: BodyPartPosition.front,
        ),
        'tibialis': BodyPart(
          title: 'body.tibialis',
          path: '//g[@id="tibialis"]/path',
          position: BodyPartPosition.front,
        ),
        'glutes': BodyPart(
          title: 'body.glutes',
          path: '//g[@id="glutes"]/path',
          position: BodyPartPosition.back,
        ),
        'hamstrings': BodyPart(
          title: 'body.hamstrings',
          path: '//g[@id="hamstrings"]/path',
          position: BodyPartPosition.back,
        ),
        'calves': BodyPart(
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
late final Box<Exercise> exerciseBox;

Future initData() async {
  maleFrontSvg = await rootBundle.loadString('assets/SVG/male_front.svg');
  maleBackSvg = await rootBundle.loadString('assets/SVG/male_back.svg');
  exerciseBox = await Hive.openBox<Exercise>(exerciseBoxName);
  // exerciseBox.deleteFromDisk();
}

const exerciseTypeOptions = <(ExerciseType, String)>[
  (ExerciseType.machineWeight, 'exercise-machine-weight'),
  (ExerciseType.freeWeight, 'exercise-free-weight'),
  (ExerciseType.bodyWeight, 'exercise-body-weight'),
  (ExerciseType.cardioMachine, 'exercise-cardio-machine'),
  (ExerciseType.stretching, 'exercise-stretching'),
  (ExerciseType.swimming, 'exercise-swimming'),
  (ExerciseType.other, 'exercise-other'),
];

typedef ExerciseTypeSpecificationValueFn = dynamic Function();
typedef ToTextConverter = String Function(dynamic value);
typedef FromTextConverter<T> = T Function(String value);
typedef IndexToEnumConverter<T> = T Function(int index);

class ExerciseTypeSpecification<T> {
  final ExerciseTypeSpecificationValueFn initValueFn;
  final FromTextConverter<T>? fromTextConverter;
  final IndexToEnumConverter<T>? indexToEnumConverter;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEnum;
  final List<(T, String)>? options;

  ExerciseTypeSpecification({
    required this.initValueFn,
    this.fromTextConverter,
    this.indexToEnumConverter,
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
      indexToEnumConverter: (index) => WeightUnit.values[index],
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
      indexToEnumConverter: (index) => WeightUnit.values[index],
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
  ExerciseType.bodyWeight: {},
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

enum WeightUnit {
  kg,
  lb,
}

const weightUnitOptions = <(WeightUnit, String)>[
  (WeightUnit.kg, 'kg'),
  (WeightUnit.lb, 'lb'),
];
