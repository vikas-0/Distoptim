import 'package:dist_guesser_application/screen/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var buttonStyle = ElevatedButton.styleFrom(
  elevation: 10,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
  minimumSize: const Size(300, 60),
);

class WelcomScreen extends StatelessWidget {
  const WelcomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.black26,
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.leaderboard),
                onPressed: () {
                  Navigator.pushNamed(context, '/leaderboard');
                },
              ),
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  showAlertDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Choose your Level',
            style: TextStyle(
              fontSize: 40,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/game',
                arguments: ScreenArguments('EASY'),
              );
            },
            child: const Text('Easy'),
            style: buttonStyle,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/game',
                arguments: ScreenArguments('MEDIUM'),
              );
            },
            child: const Text('Medium'),
            style: buttonStyle,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/game',
                arguments: ScreenArguments('HARD'),
              );
            },
            child: const Text('Hard'),
            style: buttonStyle,
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      )),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = ElevatedButton(
    child: const Text("Exit"),
    onPressed: () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Confirmation"),
    content: const Text("Are you sure you want to exit this game"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
