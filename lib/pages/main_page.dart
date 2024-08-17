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
import 'package:my_fit_journey/models/program.dart';
import 'package:my_fit_journey/models/swimming_exercise.dart';
import 'package:my_fit_journey/pages/exercise_page.dart';
import 'package:my_fit_journey/pages/exercises_page.dart';
import 'package:my_fit_journey/pages/program_page.dart';
import 'package:my_fit_journey/pages/programs_page.dart';
import 'package:my_fit_journey/pages/profile_page.dart';
import 'package:my_fit_journey/widgets/body_structure_selector.dart';

class MainPage extends StatefulWidget {
  static const String route = '/';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class Destination {
  final Icon icon;
  final String label;
  final Widget? page;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final Widget? floatingActionButton;

  const Destination({
    required this.icon,
    required this.label,
    this.page,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
    this.floatingActionButton,
  });
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;
  final _exercisesExpandableFabStateKey = GlobalKey<ExpandableFabState>();

  List<Destination> getDestinations(BuildContext context) {
    return [
      Destination(
        icon: const Icon(Icons.explore_rounded),
        label: 'Programs',
        page: const ProgramsPage(),
        floatingActionButton: FloatingActionButton(
          heroTag: 'floatingActionButton',
          onPressed: () {
            _addProgram(Program.empty());
          },
          child: const Icon(Icons.add),
        ),
      ),
      Destination(
        icon: const Icon(Icons.emoji_people),
        label: 'Exercises',
        page: const ExercisesPage(),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: _exercisesExpandableFabStateKey,
          type: ExpandableFabType.up,
          distance: 70,
          childrenAnimation: ExpandableFabAnimation.none,
          overlayStyle: ExpandableFabOverlayStyle(
            color: Colors.black.withOpacity(0.25),
            blur: 3,
          ),
          openButtonBuilder: DefaultFloatingActionButtonBuilder(
            heroTag: 'floatingActionButton',
            child: const Icon(Icons.add),
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            heroTag: 'floatingActionButton',
            child: const Icon(Icons.close),
            fabSize: ExpandableFabSize.small,
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
      ),
      Destination(
        icon: const Icon(Icons.boy_rounded),
        label: 'Body',
        page: BodyStructureSelector(
          frontSvg: maleFrontSvg,
          backSvg: maleBackSvg,
        ),
      ),
      const Destination(
        icon: Icon(Icons.person),
        label: 'Profile',
        page: ProfilePage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mainApp = context.findAncestorStateOfType<MainAppState>()!;
    final destinations = getDestinations(context);
    final destination = destinations[currentPageIndex];

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
        child: destination.page ??
            const Center(
              child: Text('Not implemented yet'),
            ),
      ),
      floatingActionButtonLocation: destination.floatingActionButtonLocation,
      floatingActionButton: destination.floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() => currentPageIndex = index);
        },
        destinations: [
          for (var dest in destinations)
            NavigationDestination(icon: dest.icon, label: dest.label)
        ],
      ),
    );
  }

  void _addProgram(Program program) {
    Navigator.of(context).pushNamed(ProgramPage.route, arguments: program);
  }

  void _addExercise(Exercise exercise) {
    if (_exercisesExpandableFabStateKey.currentState!.isOpen) {
      _exercisesExpandableFabStateKey.currentState!.toggle();
    }

    Navigator.of(context).pushNamed(ExercisePage.route, arguments: exercise);
  }
}
