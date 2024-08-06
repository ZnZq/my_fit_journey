import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/main.dart';
import 'package:my_fit_journey/pages/exercise_page.dart';
import 'package:my_fit_journey/pages/program_page.dart';
import 'package:my_fit_journey/pages/profile_page.dart';
import 'package:my_fit_journey/widgets/body_structure_selector.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

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
          ExercisePage(),
          BodyStructureSelector(
            frontSvg: maleFrontSvg,
            backSvg: maleBackSvg,
          ),
          const ProfilePage(),
        ][currentPageIndex],
      ),
      floatingActionButton: [
        null,
        FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add-exercise');
            },
            child: const Icon(Icons.add)),
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
}
