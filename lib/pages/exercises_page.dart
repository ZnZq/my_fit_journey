// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/pages/exercise_page.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final Map<String, BodyGroup> bodyStructure = getBodyStructure();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: exerciseBox.listenable(),
      builder: (context, Box<Exercise> box, index) {
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final exercise = box.getAt(index)!;
            return _buildExerciseCard(context, exercise);
          },
        );
      },
    );
  }

  // Widget _buildExerciseAddCard(BuildContext context) {
  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.only(
          left: globalPadding * 2, right: globalPadding * 2),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Delete',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(globalPadding * 2),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          key: Key(exercise.id),
          onDismissed: (direction) {
            setState(() {
              exerciseBox.delete(exercise.id);
            });
          },
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ExercisePage.route, arguments: exercise);
            },
            child: SizedBox(
              width: double.infinity,
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(globalPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exercise.title),
                          if (exercise.description.isNotEmpty)
                            Text(
                              exercise.description,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          Spacer(),
                          for (var spec
                              in exerciseTypeSpecifications[exercise.type]!
                                  .entries)
                            Text(
                              '${spec.key}: ${spec.value.isEnum ? spec.value.indexToEnumConverter!(exercise.specifications[spec.key]).toString().split('.').last : exercise.specifications[spec.key]}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SvgHighlight(
                        svgCode: maleFrontSvg,
                        highlightParts: exercise.bodyParts,
                      ),
                    ),
                    Flexible(
                      child: SvgHighlight(
                        svgCode: maleBackSvg,
                        highlightParts: exercise.bodyParts,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
