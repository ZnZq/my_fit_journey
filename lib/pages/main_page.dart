import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:my_fit_journey/const.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/program.dart';
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
        floatingActionButton: null,
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
        child: destination.page ??
            const Center(
              child: Text('Not implemented yet'),
            ),
        // child: Stack(
        //   children: [
        // Container(
        //   clipBehavior: Clip.hardEdge,
        //   padding: EdgeInsets.only(top: _containerHeight + kGap),
        //   decoration: const BoxDecoration(),
        //   child: destination.page ??
        //       const Center(
        //         child: Text('Not implemented yet'),
        //       ),
        // ),
        // Container(
        //   key: _containerKey,
        //   decoration: const BoxDecoration(
        //     color: kBackgroundColor,
        //     boxShadow: [
        //       BoxShadow(
        //         color: kDarkShadowColor,
        //         offset: Offset(2, 2),
        //         spreadRadius: 1,
        //         blurRadius: 2,
        //       ),
        //     ],
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.all(kGap * 2),
        //     child: Row(
        //       children: [
        //         Text(
        //           destination.label,
        //           style: Theme.of(context).textTheme.headlineLarge,
        //         ),
        //         const Spacer(),
        //         destination.floatingActionButton ?? const SizedBox.shrink(),
        //       ],
        //     ),
        //   ),
        // ),
        // ],
        // ),
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
}
