import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
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
import 'package:my_fit_journey/pages/extensions.dart';
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
        floatingActionButton: Container(
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
          child: IconButton(
            onPressed: () async {
              final exercise = await showDialog<Exercise?>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: kBackgroundColor,
                  title: Text(
                    'add-exercise'.i18n(),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildAddExerciseOption(
                        'machine-weight'.i18n(),
                        Icons.gavel_rounded,
                        ExerciseType.machineWeight.color,
                        MachineWeightExercise.empty(),
                        paddingTop: 0,
                      ),
                      _buildAddExerciseOption(
                        'free-weight'.i18n(),
                        Icons.rowing_rounded,
                        ExerciseType.freeWeight.color,
                        FreeWeightExercise.empty(),
                      ),
                      _buildAddExerciseOption(
                        'body-weight'.i18n(),
                        Icons.sports_gymnastics,
                        ExerciseType.bodyWeight.color,
                        BodyWeightExercise.empty(),
                      ),
                      _buildAddExerciseOption(
                        'cardio-machine'.i18n(),
                        Icons.monitor_heart_rounded,
                        ExerciseType.cardioMachine.color,
                        CardioMachineExercise.empty(),
                      ),
                      _buildAddExerciseOption(
                        'swimming'.i18n(),
                        Icons.pool_rounded,
                        ExerciseType.swimming.color,
                        SwimmingExercise.empty(),
                      ),
                      _buildAddExerciseOption(
                        'other'.i18n(),
                        Icons.pie_chart_outline_sharp,
                        ExerciseType.other.color,
                        OtherExercise.empty(),
                      ),
                    ],
                  ),
                ),
              );

              if (exercise != null) {
                _addExercise(exercise);
              }
            },
            icon: const Icon(Icons.add),
          ),
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

  Widget _buildAddExerciseOption(
    String text,
    IconData icon,
    Color color,
    Exercise exercise, {
    double paddingTop = kGap * 2,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Container(
        padding: const EdgeInsets.all(kGap),
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(kGap * 2),
          boxShadow: const [
            BoxShadow(
              color: kDarkShadowColor,
              offset: Offset(4, 4),
              spreadRadius: 1,
              blurRadius: 4,
            ),
            BoxShadow(
              color: kLightShadowColor,
              offset: Offset(-4, -4),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop(exercise);
          },
          child: Padding(
            padding: const EdgeInsets.all(kGap),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: kGap),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final mainApp = context.findAncestorStateOfType<MainAppState>()!;
    final destinations = getDestinations(context);
    final destination = destinations[currentPageIndex];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('app-title'.i18n(),),
      //   actions: [
      //     PopupMenuButton<Locale>(
      //       icon: const Icon(Icons.language),
      //       onSelected: (value) {
      //         mainApp.changeLocale(value);
      //       },
      //       itemBuilder: (context) {
      //         return [
      //           PopupMenuItem(
      //             value: const Locale('en'),
      //             enabled: mainApp.locale?.languageCode != 'en',
      //             child: ListTile(
      //               leading: CountryFlag.fromCountryCode("us"),
      //               title: Text('english'.i18n(),),
      //             ),
      //           ),
      //           PopupMenuItem(
      //             value: const Locale('uk'),
      //             enabled: mainApp.locale?.languageCode != 'uk',
      //             child: ListTile(
      //               leading: CountryFlag.fromCountryCode("ua"),
      //               title: Text('ukranian'.i18n(),),
      //             ),
      //           ),
      //         ];
      //       },
      //     ),
      //   ],
      // ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.only(top: 80),
              decoration: const BoxDecoration(),
              child: destination.page ??
                  const Center(
                    child: Text('Not implemented yet'),
                  ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: kBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: kDarkShadowColor,
                    offset: Offset(0, 2),
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(kGap * 2),
                child: Row(
                  children: [
                    Text(
                      destination.label,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const Spacer(),
                    destination.floatingActionButton ?? const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButtonLocation: destination.floatingActionButtonLocation,
      // floatingActionButton: destination.floatingActionButton,
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
    Navigator.of(context).pushNamed(ExercisePage.route, arguments: exercise);
  }
}
