import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/models/program.dart';
import 'package:my_fit_journey/pages/exercise_page.dart';
import 'package:my_fit_journey/pages/body_selector_page.dart';
import 'package:my_fit_journey/pages/main_page.dart';
import 'package:my_fit_journey/pages/program_page.dart';
import 'package:my_fit_journey/storage/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initData();
  await Storage.initialize();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  Locale? locale;

  changeLocale(Locale locale) {
    setState(() {
      this.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('uk'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (supportedLocales.contains(locale)) {
          return locale;
        }

        if (locale?.languageCode == 'uk') {
          return const Locale('uk');
        }

        return const Locale('en');
      },
      initialRoute: '/',
      routes: {
        MainPage.route: (context) => const MainPage(),
        BodySelectorPage.route: (context) => BodySelectorPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ExercisePage.route) {
          final exercise = settings.arguments as Exercise?;
          if (exercise != null) {
            return MaterialPageRoute(
              builder: (context) => ExercisePage(exercise: exercise),
            );
          }
        }

        if (settings.name == ProgramPage.route) {
          final program = settings.arguments as Program?;
          if (program != null) {
            return MaterialPageRoute(
              builder: (context) => ProgramPage(program: program),
            );
          }
        }

        assert(false, 'Need to implement ${settings.name} or empty arguments');

        return null;
      },
    );
  }
}
