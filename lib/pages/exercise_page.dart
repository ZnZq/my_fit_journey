// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';

class ExercisePage extends StatelessWidget {
  final Map<String, BodyGroup> bodyStructure = getBodyStructure();

  ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(width: globalPadding * 2),
          // _buildExerciseAddCard(context),
          _buildExerciseCard(context),
          _buildExerciseCard(context),
          _buildExerciseCard(context),
          _buildExerciseCard(context),
          _buildExerciseCard(context),
          SizedBox(width: globalPadding * 2),
        ],
      ),
    );
  }

  // Widget _buildExerciseAddCard(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(
  //         left: globalPadding * 2, right: globalPadding * 2),
  //     child: Card(
  //       child: InkWell(
  //         onTap: () {
  //           Navigator.of(context).pushNamed('/add-exercise');
  //         },
  //         child: SizedBox(
  //           width: double.infinity,
  //           height: 150,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(Icons.add_box_outlined, size: 50),
  //               Text('add-exercise'.i18n()),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildExerciseCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: globalPadding * 2, right: globalPadding * 2),
      child: Card(
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
                  child: Text('program-name'.i18n()),
                ),
                Flexible(
                  child: SvgHighlight(
                    svgCode: maleFrontSvg,
                    highlightParts:
                        bodyStructure['arms']!.children.values.toList(),
                  ),
                ),
                Flexible(
                  child: SvgHighlight(
                    svgCode: maleBackSvg,
                    highlightParts:
                        bodyStructure['torso']!.children.values.toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
