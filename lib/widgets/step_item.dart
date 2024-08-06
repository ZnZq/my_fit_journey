import 'package:flutter/material.dart';
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
        left: globalPadding,
        bottom: globalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: globalPadding * 4 + 1,
                height: globalPadding * 4 + 1,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(globalPadding * 4),
                ),
                child: Center(
                  child: Text(
                    index.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: globalPadding),
              Expanded(child: title),
              const Spacer(),
              actions,
              const SizedBox(width: globalPadding),
            ],
          ),
          const SizedBox(height: globalPadding),
          LayoutBuilder(
            builder: (context, constraints) {
              return IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: globalPadding * 2),
                      child: Container(
                        color: color,
                        width: 1,
                      ),
                    ),
                    Expanded(child: child),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
