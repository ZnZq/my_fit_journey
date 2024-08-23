import 'package:flutter/material.dart';

const double kGap = 8.0;
const Color kBackgroundColor = Color.fromRGBO(0xE0, 0xE5, 0xEC, 1);
const Color kLightShadowColor = Color.fromRGBO(0xFF, 0xFF, 0xFF, 1);
const Color kDarkShadowColor = Color.fromRGBO(0xA3, 0xB1, 0xC6, 1);

const Color kTextColorLight = Color.fromRGBO(0x88, 0x88, 0x88, 1);
const Color kTextColorMedium = Color.fromRGBO(0x66, 0x66, 0x66, 1);
const Color kTextColorDark = Color.fromRGBO(0x44, 0x44, 0x44, 1);

ThemeData buildLightTheme(BuildContext context) {
  final theme = ThemeData.light();

  return theme.copyWith(
    textTheme: TextTheme(
      titleLarge: theme.textTheme.titleLarge!.copyWith(
        color: kTextColorDark,
      ),
      titleMedium: theme.textTheme.titleMedium!.copyWith(
        color: kTextColorDark,
      ),
      titleSmall: theme.textTheme.titleSmall!.copyWith(
        color: kTextColorDark,
      ),
      bodyLarge: theme.textTheme.bodyLarge!.copyWith(
        color: kTextColorDark,
      ),
      bodyMedium: theme.textTheme.bodyMedium!.copyWith(
        color: kTextColorDark,
      ),
      bodySmall: theme.textTheme.bodySmall!.copyWith(
        color: kTextColorDark,
      ),
      labelLarge: theme.textTheme.labelLarge!.copyWith(
        color: kTextColorDark,
      ),
      labelMedium: theme.textTheme.labelMedium!.copyWith(
        color: kTextColorDark,
      ),
      labelSmall: theme.textTheme.labelSmall!.copyWith(
        color: kTextColorDark,
      ),
      displayLarge: theme.textTheme.displayLarge!.copyWith(
        color: kTextColorDark,
      ),
      displayMedium: theme.textTheme.displayMedium!.copyWith(
        color: kTextColorDark,
      ),
      displaySmall: theme.textTheme.displaySmall!.copyWith(
        color: kTextColorDark,
      ),
      headlineLarge: theme.textTheme.headlineLarge!.copyWith(
        color: kTextColorDark,
      ),
      headlineMedium: theme.textTheme.headlineMedium!.copyWith(
        color: kTextColorDark,
      ),
      headlineSmall: theme.textTheme.headlineSmall!.copyWith(
        color: kTextColorDark,
      ),
    ),
  );
}
