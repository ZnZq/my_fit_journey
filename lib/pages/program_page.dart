import 'package:flutter/material.dart';
import 'package:my_fit_journey/models/program.dart';

class ProgramPage extends StatefulWidget {
  static const String route = '/program';
  final Program program;

  const ProgramPage({super.key, required this.program});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
