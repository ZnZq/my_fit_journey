import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localization/localization.dart';
import 'package:my_fit_journey/data.dart';
import 'package:my_fit_journey/models/body_part.dart';
import 'package:my_fit_journey/models/exercise.dart';
import 'package:my_fit_journey/models/exercise_photo.dart';
import 'package:my_fit_journey/pages/exercise_page.dart';
import 'package:my_fit_journey/pages/body_selector_page.dart';
import 'package:my_fit_journey/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(ExercisePhotoAdapter());
  Hive.registerAdapter(BodyPartAdapter());

  await initData();

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
        // ExercisePage.route: (context) => const ExercisePage(),
        BodySelectorPage.route: (context) => BodySelectorPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ExercisePage.route) {
          final exercise = settings.arguments as Exercise?;
          return MaterialPageRoute(
            builder: (context) => ExercisePage(exercise: exercise),
          );
        }

        assert(false, 'Need to implement ${settings.name}');

        return null;
      },
    );
  }
}
