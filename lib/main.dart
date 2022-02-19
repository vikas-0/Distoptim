import 'package:dist_guesser_application/screen/about.dart';
import 'package:dist_guesser_application/screen/game.dart';
import 'package:dist_guesser_application/screen/leaderboard.dart';
import 'package:dist_guesser_application/screen/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
// Import the generated file
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Distance Guesser',
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.indigo,
          canvasColor: Colors.indigo.shade900,
          textTheme: GoogleFonts.shareTechMonoTextTheme(
            const TextTheme(
              headline1: TextStyle(
                fontSize: 72.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headline2: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headline3: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headline4: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headline5: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headline6: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              bodyText1: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              bodyText2: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              button: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              caption: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overline: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const WelcomScreen(),
        '/game': (BuildContext context) => const GameScreen(),
        '/leaderboard': (BuildContext context) => const LeaderBoardScreen(),
        '/about': (BuildContext context) => const AboutScreen()
      },
      initialRoute: '/',
    );
  }
}
