// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ExerciseStep {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final bool isShowContinueButton;

  ExerciseStep({
    required this.title,
    required this.content,
    this.actions = const [],
    this.isShowContinueButton = true,
  });
}
