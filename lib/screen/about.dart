import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About'),
          backgroundColor: Colors.black26,
        ),
        body: Container(
            padding: EdgeInsets.all(30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('How to Play', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 5),
                  Text(
                      'A plane is going to drop gifts to various cities. You\'ll have to sort cities in such a way that when the plane travells from cities in order sorted by you, it has to fly least distance'),
                  SizedBox(height: 10),
                  Text('Scoring', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 5),
                  Text(
                      'Scoring depend on how efficient your solution is compared to initial solution. If your solution is of same efficiency as initial, you\'ll get 100 point (In a way you can get 100 points without doing anything). If it\'s less efficent, it will be lower that 100 else it will be greated than 100'),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                      'Note: This game is without any gurantee, there is no gurantee of fairness in score and leaderboard',
                      style: TextStyle(fontSize: 10))
                ])));
  }
}
