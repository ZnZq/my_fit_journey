import 'package:flutter/material.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/pages/extensions.dart';

class StackAppBarButton extends StatelessWidget {
  final Widget child;

  const StackAppBarButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: kBackgroundColor,
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kBackgroundColor.mix(kDarkShadowColor, .75),
            kBackgroundColor,
            kBackgroundColor,
            kBackgroundColor.mix(kLightShadowColor, .75),
          ],
          stops: const [0.0, .3, .6, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: kLightShadowColor,
            offset: Offset(-4, -4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: kDarkShadowColor,
            offset: Offset(4, 4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
