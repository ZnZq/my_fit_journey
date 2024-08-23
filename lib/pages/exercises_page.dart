// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/pages/exercise_page.dart';
import 'package:my_fit_journey/storage/storage.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';
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
    return Padding(
      padding: const EdgeInsets.only(left: kGap, right: kGap),
      child: ListenableBuilder(
        listenable: Storage.exerciseStorage,
        builder: (context, child) {
          return ReorderableListView(
            clipBehavior: Clip.none,
            children: [
              for (final exercise in Storage.exerciseStorage.items)
                _buildExerciseCard(context, exercise),
            ],
            onReorder: (oldIndex, newIndex) {
              Storage.exerciseStorage.moveTo(oldIndex, newIndex);
            },
          );
        },
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    return Padding(
      key: ValueKey(exercise.id),
      padding: const EdgeInsets.all(kGap),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(kGap * 2),
          boxShadow: [
            BoxShadow(
              color: kLightShadowColor,
              offset: Offset(-5, -5),
              blurRadius: 5,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: kDarkShadowColor,
              offset: Offset(5, 5),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Dismissible(
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
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ExercisePage.route, arguments: exercise);
            },
            child: SizedBox(
              width: double.infinity,
              height: 125,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: kGap * 1.5,
                  top: kGap * 1.5,
                  bottom: kGap * 1.5,
                  right: kGap,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: kGap / 2),
                            child: Text(
                              exercise.title,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          if (exercise.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: kGap / 2),
                              child: Text(
                                exercise.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: kTextColorLight),
                              ),
                            ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: exercise.type.color,
                              borderRadius: BorderRadius.circular(kGap),
                              boxShadow: [
                                BoxShadow(
                                  color: kLightShadowColor,
                                  offset: Offset(-2, -2),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  // inset: true,
                                ),
                                BoxShadow(
                                  color: exercise.type.color.withOpacity(0.5),
                                  offset: Offset(2, 2),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  // inset: true,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kGap,
                                vertical: kGap / 4,
                              ),
                              child: Text(
                                exercise.type.toString().split('.').last,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Color.lerp(exercise.type.color,
                                          Colors.white, 0.8),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(kGap),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kGap),
                        color: kBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: kLightShadowColor,
                            offset: Offset(-2, -2),
                            blurRadius: 2,
                            spreadRadius: 1,
                            inset: true,
                          ),
                          BoxShadow(
                            color: kDarkShadowColor,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                            spreadRadius: 1,
                            inset: true,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SvgHighlight(
                              svgCode: maleFrontSvg,
                              highlightParts: exercise.bodyParts,
                            ),
                          ),
                          Expanded(
                            child: SvgHighlight(
                              svgCode: maleBackSvg,
                              highlightParts: exercise.bodyParts,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: kGap / 2),
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
