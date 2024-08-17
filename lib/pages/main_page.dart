import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/main.dart';
import 'package:my_fit_journey/models/body_weight_exercise.dart';
import 'package:my_fit_journey/models/cardio_machine_exercise.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/models/free_weight_exercise.dart';
import 'package:my_fit_journey/models/machine_weight_exercise.dart';
import 'package:my_fit_journey/models/other_exercise.dart';
import 'package:my_fit_journey/models/swimming_exercise.dart';
import 'package:my_fit_journey/pages/exercise_page.dart';
import 'package:my_fit_journey/pages/exercises_page.dart';
import 'package:my_fit_journey/pages/program_page.dart';
import 'package:my_fit_journey/pages/profile_page.dart';
import 'package:my_fit_journey/widgets/body_structure_selector.dart';

class MainPage extends StatefulWidget {
  static const String route = '/';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;
  final _expandableFabStateKey = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    // final locale = Localizations.localeOf(context);
    final mainApp = context.findAncestorStateOfType<MainAppState>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text('app-title'.i18n()),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (value) {
              mainApp.changeLocale(value);
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: const Locale('en'),
                  enabled: mainApp.locale?.languageCode != 'en',
                  child: ListTile(
                    leading: CountryFlag.fromCountryCode("us"),
                    title: Text('english'.i18n()),
                  ),
                ),
                PopupMenuItem(
                  value: const Locale('uk'),
                  enabled: mainApp.locale?.languageCode != 'uk',
                  child: ListTile(
                    leading: CountryFlag.fromCountryCode("ua"),
                    title: Text('ukranian'.i18n()),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: [
          const ProgramPage(),
          const ExercisesPage(),
          BodyStructureSelector(
            frontSvg: maleFrontSvg,
            backSvg: maleBackSvg,
          ),
          const ProfilePage(),
        ][currentPageIndex],
      ),
      floatingActionButtonLocation: [
        null,
        ExpandableFab.location,
        null,
        null,
      ][currentPageIndex],
      floatingActionButton: [
        null,
        ExpandableFab(
          key: _expandableFabStateKey,
          type: ExpandableFabType.up,
          distance: 70,
          childrenAnimation: ExpandableFabAnimation.none,
          overlayStyle: ExpandableFabOverlayStyle(
            color: Colors.black.withOpacity(0.25),
            blur: 3,
          ),
          children: [
            FloatingActionButton.extended(
              heroTag: 'MachineWeightExercise',
              label: Text('machine-weight'.i18n()),
              icon: const Icon(Icons.gavel_rounded),
              onPressed: () {
                _addExercise(MachineWeightExercise.empty());
              },
            ),
            FloatingActionButton.extended(
              heroTag: 'FreeWeightExercise',
              label: Text('free-weight'.i18n()),
              icon: const Icon(Icons.rowing_rounded),
              onPressed: () {
                _addExercise(FreeWeightExercise.empty());
              },
            ),
            FloatingActionButton.extended(
              heroTag: 'BodyWeightExercise',
              label: Text('body-weight'.i18n()),
              icon: const Icon(Icons.sports_gymnastics),
              onPressed: () {
                _addExercise(BodyWeightExercise.empty());
              },
            ),
            FloatingActionButton.extended(
              heroTag: 'CardioMachineExercise',
              label: Text('cardio-machine'.i18n()),
              icon: const Icon(Icons.monitor_heart_rounded),
              onPressed: () {
                _addExercise(CardioMachineExercise.empty());
              },
            ),
            FloatingActionButton.extended(
              heroTag: 'SwimmingExercise',
              label: Text('swimming'.i18n()),
              icon: const Icon(Icons.pool_rounded),
              onPressed: () {
                _addExercise(SwimmingExercise.empty());
              },
            ),
            FloatingActionButton.extended(
              heroTag: 'OtherExercise',
              label: Text('other'.i18n()),
              icon: const Icon(Icons.pie_chart_outline_sharp),
              onPressed: () {
                _addExercise(OtherExercise.empty());
              },
            ),
          ],
        ),
        null,
        null,
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() => currentPageIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_rounded),
            label: 'Programs',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_people),
            label: 'Exercises',
          ),
          NavigationDestination(
            icon: Icon(Icons.boy_rounded),
            label: 'Body',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _addExercise(Exercise exercise) {
    if (_expandableFabStateKey.currentState!.isOpen) {
      _expandableFabStateKey.currentState!.toggle();
    }
    Navigator.of(context).pushNamed(ExercisePage.route, arguments: exercise);
  }
}
