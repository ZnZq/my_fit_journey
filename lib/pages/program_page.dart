// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/widgets/svg_highlight.dart';

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  late final Map<String, BodyGroup> bodyStructure;

  @override
  void initState() {
    bodyStructure = getBodyStructure();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: globalPadding * 2),
            child: Text(
              'active-programs'.i18n(),
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(height: globalPadding),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: globalPadding * 3),
                _buildActiveProgramCard(context),
                _buildActiveProgramCard(context),
                _buildActiveProgramCard(context),
                _buildActiveProgramCard(context),
                _buildActiveProgramCard(context),
                SizedBox(width: globalPadding * 3),
              ],
            ),
          ),
          SizedBox(height: globalPadding),
          Padding(
            padding: const EdgeInsets.only(left: globalPadding * 2),
            child: Text(
              'avaliable-programs'.i18n(),
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(height: globalPadding),
          Column(
            children: [
              SizedBox(width: globalPadding * 3),
              _buildAvaliableProgramCard(context),
              _buildAvaliableProgramCard(context),
              _buildAvaliableProgramCard(context),
              _buildAvaliableProgramCard(context),
              _buildAvaliableProgramCard(context),
              SizedBox(width: globalPadding * 3),
            ],
          ),
          SizedBox(height: globalPadding),
        ],
      ),
    );
  }

  Widget _buildAvaliableProgramCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: globalPadding * 3, right: globalPadding * 3),
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

  Widget _buildActiveProgramCard(BuildContext context) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.25 - globalPadding,
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
    );
  }
}
