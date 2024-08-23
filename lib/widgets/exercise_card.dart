import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/widgets/exercise_type_chip.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;
  final Widget Function(BuildContext context, Widget child) builder;
  final double height;
  final double bodySize;
  final bool isCompact;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
    required this.builder,
    this.height = 125,
    this.bodySize = 100,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kGap),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(kGap * 2),
          boxShadow: const [
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
        child: builder(
          context,
          InkWell(
            onTap: onTap,
            child: SizedBox(
              width: double.infinity,
              height: isCompact ? 95 : 125,
              child: Padding(
                padding: EdgeInsets.only(
                  left: kGap * (isCompact ? 1.0 : 1.5),
                  top: kGap * (isCompact ? 1.0 : 1.5),
                  bottom: kGap * (isCompact ? 1.0 : 1.5),
                  right: kGap * (isCompact ? 0.5 : 1.0),
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
                              style: isCompact
                                  ? Theme.of(context).textTheme.bodyMedium
                                  : Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          if (exercise.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: kGap / 2),
                              child: Text(
                                exercise.description,
                                softWrap: true,
                                maxLines: 2,
                                style: (isCompact
                                        ? Theme.of(context).textTheme.bodySmall
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyMedium)
                                    ?.copyWith(color: kTextColorLight),
                              ),
                            ),
                          const Spacer(),
                          ExerciseTypeChip(
                            type: exercise.type,
                            color: exercise.type.color,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: isCompact ? 80 : 100,
                      height: isCompact ? 80 : 100,
                      padding: const EdgeInsets.all(kGap),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kGap),
                        color: kBackgroundColor,
                        boxShadow: const [
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
                    const SizedBox(width: kGap / 2),
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
