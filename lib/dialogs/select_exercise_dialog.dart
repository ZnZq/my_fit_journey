import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/storage/storage.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';
import 'package:my_fit_journey/models/exercise.dart';

class SelectExerciseDialog extends StatelessWidget {
  const SelectExerciseDialog({super.key});

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
              child: Text('select-exercise'.i18n()),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(height: 1),
                shrinkWrap: true,
                itemCount: Storage.exerciseStorage.items.length,
                itemBuilder: (context, index) {
                  final exercise = Storage.exerciseStorage.items[index];
                  return ListTile(
                    title: Text(exercise.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: globalPadding / 2),
                        Container(
                          decoration: BoxDecoration(
                            color: exercise.type.color,
                            borderRadius: BorderRadius.circular(globalPadding),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: globalPadding,
                              vertical: globalPadding / 4,
                            ),
                            child: Text(
                              exercise.type.toString().split('.').last,
                              style: TextStyle(
                                fontSize: 10,
                                color: Color.lerp(
                                    exercise.type.color, Colors.white, 0.8),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 32,
                          child: SvgHighlight(
                            svgCode: maleFrontSvg,
                            highlightParts: exercise.bodyParts,
                          ),
                        ),
                        SizedBox(
                          width: 32,
                          child: SvgHighlight(
                            svgCode: maleBackSvg,
                            highlightParts: exercise.bodyParts,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context, exercise);
                    },
                  );
                },
              ),
            ),
            // const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
