import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:my_fit_journey/const.dart';

class StepItem extends StatelessWidget {
  final int index;
  final Widget title;
  final Widget child;
  final Color color;
  final Widget actions;

  const StepItem({
    super.key,
    required this.index,
    required this.title,
    required this.child,
    this.color = Colors.indigo,
    this.actions = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: kGap,
        bottom: kGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: kGap * 4 + 1,
                height: kGap * 4 + 1,
                decoration: const BoxDecoration(
                  color: kBackgroundColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kLightShadowColor,
                      offset: Offset(-3, -3),
                      blurRadius: 3,
                      spreadRadius: 1,
                      inset: true,
                    ),
                    BoxShadow(
                      color: kDarkShadowColor,
                      offset: Offset(3, 3),
                      blurRadius: 3,
                      spreadRadius: 1,
                      inset: true,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    index.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: kGap * 2),
              Expanded(child: title),
              const Spacer(),
              actions,
              const SizedBox(width: kGap * 2),
            ],
          ),
          const SizedBox(height: kGap),
          Stack(
            children: [
              Positioned(
                left: kGap * 2 - 1,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 1,
                  decoration: const BoxDecoration(
                    color: kBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: kLightShadowColor,
                        offset: Offset(-1, -1),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: kDarkShadowColor,
                        offset: Offset(1, 1),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: kGap * 4),
                child: child,
              ),
            ],
          )
        ],
      ),
    );
  }
}
