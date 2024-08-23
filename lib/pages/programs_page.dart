// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/program.dart';
import 'package:my_fit_journey/storage/storage.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';

class ProgramsPage extends StatefulWidget {
  const ProgramsPage({super.key});

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  late final Map<String, BodyGroup> bodyStructure;

  @override
  void initState() {
    bodyStructure = getBodyStructure();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: kGap, right: kGap),
      child: ListenableBuilder(
        listenable: Storage.exerciseStorage,
        builder: (context, child) {
          return ReorderableListView(
            children: [
              for (final program in Storage.programStorage.items)
                _buildProgramCard(context, program),
            ],
            onReorder: (oldIndex, newIndex) {
              Storage.programStorage.moveTo(oldIndex, newIndex);
            },
          );
        },
      ),
    );
  }

  Widget _buildProgramCard(BuildContext context, Program program) {
    final bodyParts = program.getBodyParts().toList();

    return Card(
      key: ValueKey(program.id),
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(kGap),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: Text(program.name)),
              Flexible(
                child: SvgHighlight(
                  svgCode: maleFrontSvg,
                  highlightParts: bodyParts,
                ),
              ),
              Flexible(
                child: SvgHighlight(
                  svgCode: maleBackSvg,
                  highlightParts: bodyParts,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
