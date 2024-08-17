import 'package:flutter/services.dart';
import 'package:my_fit_journey/models/body_part.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

late final String maleFrontSvg;
late final String maleBackSvg;

Future initData() async {
  maleFrontSvg = await rootBundle.loadString('assets/SVG/male_front.svg');
  maleBackSvg = await rootBundle.loadString('assets/SVG/male_back.svg');
}

class BodyPartPositionOption {
  final BodyPartPosition position;
  final String title;

  BodyPartPositionOption(this.position, this.title);
}

final bodyPartPositionOptions = <BodyPartPositionOption>[
  BodyPartPositionOption(BodyPartPosition.front, 'body.front-side'),
  BodyPartPositionOption(BodyPartPosition.back, 'body.back-side'),
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

class ExerciseTypeOption {
  final ExerciseType type;
  final String title;

  ExerciseTypeOption(this.type, this.title);
}

final exerciseTypeOptions = <ExerciseTypeOption>[
  ExerciseTypeOption(ExerciseType.machineWeight, 'exercise-machine-weight'),
  ExerciseTypeOption(ExerciseType.freeWeight, 'exercise-free-weight'),
  ExerciseTypeOption(ExerciseType.bodyWeight, 'exercise-body-weight'),
  ExerciseTypeOption(ExerciseType.cardioMachine, 'exercise-cardio-machine'),
  ExerciseTypeOption(ExerciseType.swimming, 'exercise-swimming'),
  ExerciseTypeOption(ExerciseType.other, 'exercise-other'),
];

final exerciseTypeMap =
    Map.fromEntries(exerciseTypeOptions.map((e) => MapEntry(e.type, e.title)));

enum WeightUnit {
  kg,
  lb,
}

class WeightUnitOption {
  final WeightUnit unit;
  final String title;

  WeightUnitOption(this.unit, this.title);
}

final weightUnitOptions = <WeightUnitOption>[
  WeightUnitOption(WeightUnit.kg, 'kg'),
  WeightUnitOption(WeightUnit.lb, 'lb'),
];
