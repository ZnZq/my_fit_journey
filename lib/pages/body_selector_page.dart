import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/widgets/body_structure_selector.dart';

class BodySelectorPage extends StatelessWidget {
  final BodyStructureSelectorController controller =
      BodyStructureSelectorController();

  BodySelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final parts = ModalRoute.of(context)!.settings.arguments as List<BodyPart>;
    controller.selectedParts.clear();
    controller.selectedParts.addAll(parts);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('body-structure'.i18n()),
      ),
      body: SafeArea(
        child: BodyStructureSelector(
          controller: controller,
          frontSvg: maleFrontSvg,
          backSvg: maleBackSvg,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(globalPadding),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: Text('cancel'.i18n()),
              ),
            ),
            const SizedBox(width: globalPadding),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(controller.selectedParts);
                },
                child: Text('select'.i18n()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
