import 'package:flutter/material.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/models/exercise.dart';

class ExerciseTypeChip extends StatelessWidget {
  final Color color;
  final ExerciseType type;

  const ExerciseTypeChip({super.key, required this.type, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(kGap),
        boxShadow: [
          const BoxShadow(
            color: kLightShadowColor,
            offset: Offset(-2, -2),
            blurRadius: 2,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: color.withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kGap,
          vertical: kGap / 4,
        ),
        child: Text(
          type.toString().split('.').last,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Color.lerp(color, Colors.white, 0.8),
              ),
        ),
      ),
    );
  }
}
