import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:dist_guesser_application/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:localstorage/localstorage.dart';

var buttonStyle = ElevatedButton.styleFrom(
  elevation: 10,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
  minimumSize: const Size(300, 60),
);

class ScreenArguments {
  final String level;
  ScreenArguments(this.level);
}

const totalSteps = 5;
const duration = 25;

class GameScreen extends StatefulWidget {
  const GameScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final Iterable<City> cityList;
  late List<City> cityListToDisplay = [];
  final _controller = CountDownController();
  var round = 1;
  var scoreBase = 1.0;
  var score = 0;
  var done = false;
  final player = AudioCache();

  //form
  var name = '';
  var submitToGlobal = false;

  @override
  void initState() {
    super.initState();
    loadData().then((value) => {
          setState(() {
            cityList = value;
            cityListToDisplay = getRandomCity();
          })
        });
  }

  getRandomCity() {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    var count = 0;

    if (args.level == 'EASY') {
      count = 3;
    } else if (args.level == 'MEDIUM') {
      count = 5;
    } else if (args.level == 'HARD') {
      count = 8;
    }

    var random = Random();
    var randomIndex = random.nextInt(cityList.length);

    var b = 0.0;

    List<City> list = [];
    for (var i = 0; i < count; i++) {
      list.add(cityList.elementAt(randomIndex));
      if (i != 0) {
        var prevItem = list[i - 1];
        var curretnItem = cityList.elementAt(randomIndex);
        var dist = calculateDistance(prevItem.latitiude, prevItem.longitude,
            curretnItem.latitiude, curretnItem.longitude);
        b += dist;
      }
      scoreBase = b;
      randomIndex = random.nextInt(cityList.length);
    }

    return list;
  }

  int getScore() {
    var score = 0;
    var distance = 0.0;
    for (var i = 1; i < cityListToDisplay.length; i++) {
      distance += calculateDistance(
          cityListToDisplay[i - 1].latitiude,
          cityListToDisplay[i - 1].longitude,
          cityListToDisplay[i].latitiude,
          cityListToDisplay[i].longitude);
    }
    score = ((scoreBase / distance) * 100).round();
    return score;
  }

  submitResult() {
    _controller.pause();
    if (round < totalSteps) {
      player.play('next.mp3');
      setState(() {
        if (!done) {
          score += getScore();
        }
        cityListToDisplay = getRandomCity();
        round++;
        _controller.restart(initialPosition: 0, duration: duration);
      });
    } else {
      //next page
      player.play('game_end.wav');
      if (!done) {
        score += getScore();
      }

      setState(() {
        done = true;
      });

      showGameEndDialog(context);
    }
  }

  saveScore() {
    final storage = LocalStorage('score_data.json');
    //save score local
    storage.ready.then((ready) {
      ScoreList list = ScoreList();
      var i = storage.getItem('score_list') ?? [];
      list.fromJson(i);
      list.items.add(ScoreItem(name: name, score: score));
      storage.setItem('score_list', list.toJSONEncodable());
      if (submitToGlobal) {
        scoreRef
            .add(
              ScoreItem(name: name, score: score),
            )
            .then((value) => {Navigator.pushReplacementNamed(context, '/')});
      } else {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  showGameEndDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pushNamed(context, '/');
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Submit"),
      onPressed: () {
        saveScore();
      },
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Game Over", style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 10),
                  Text("Your score is $score",
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  const Text(
                      "Please Enter a name if you want to submit your score to leaderboard"),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    maxLength: 15,
                    onChanged: (String value) {
                      name = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text('Also submit to global leadeboard?'),
                    value: submitToGlobal,
                    onChanged: (bool? value) {
                      setState(() {
                        submitToGlobal = value ?? false;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      cancelButton,
                      continueButton,
                    ],
                  )
                ]);
          }));
        });
  }

  @override
  Widget build(BuildContext context) {
    // showGameEndDialog(context);
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Keep Sorting',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: CountDownProgressIndicator(
                  controller: _controller,
                  valueColor: Colors.red,
                  backgroundColor: Colors.blue,
                  initialPosition: 0,
                  duration: duration,
                  timeFormatter: (seconds) {
                    return seconds.toString();
                  },
                  timeTextStyle:
                      const TextStyle(fontSize: 20, color: Colors.white),
                  onComplete: () {
                    submitResult();
                  },
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text('Round $round of $totalSteps'),
              Text('Score $score', style: const TextStyle(fontSize: 20)),
              ImplicitlyAnimatedReorderableList<City>(
                items: cityListToDisplay,
                areItemsTheSame: (oldItem, newItem) =>
                    oldItem.name == newItem.name,
                onReorderFinished: (item, from, to, newItems) {
                  // Remember to update the underlying data when the list has been
                  // reordered.
                  player.play('shuffle.wav');
                  setState(() {
                    cityListToDisplay = newItems;
                  });
                },
                itemBuilder: (context, itemAnimation, item, index) {
                  // Each item must be wrapped in a Reorderable widget.
                  return Reorderable(
                    // Each item must have an unique key.
                    key: ValueKey(item),

                    builder: (context, dragAnimation, inDrag) {
                      final t = dragAnimation.value;
                      final elevation = lerpDouble(0, 8, t);
                      final color = Color.lerp(
                          Colors.white, Colors.white.withOpacity(0.8), t);

                      return SizeFadeTransition(
                        sizeFraction: 0.7,
                        curve: Curves.easeInOut,
                        animation: itemAnimation,
                        child: Material(
                          color: color,
                          elevation: elevation ?? 1.0,
                          type: MaterialType.transparency,
                          child: ListTile(
                            title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text((index + 1).toString()),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  Text(item.name + ', ' + item.state,
                                      overflow: TextOverflow.ellipsis),
                                ]),
                            // The child of a Handle can initialize a drag/reorder.
                            // This could for example be an Icon or the whole item itself. You can
                            // use the delay parameter to specify the duration for how long a pointer
                            // must press the child, until it can be dragged.
                            trailing: const Handle(
                              delay: Duration(milliseconds: 100),
                              child: Icon(
                                Icons.drag_handle_outlined,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },

                // If you want to use headers or footers, you should set shrinkWrap to true
                shrinkWrap: true,
              ),
              ElevatedButton.icon(
                  onPressed: done
                      ? null
                      : () {
                          submitResult();
                        },
                  icon: done
                      ? const Icon(Icons.done_all)
                      : const Icon(Icons.done),
                  label: const Text('Submit'),
                  style: buttonStyle),
              const SizedBox(
                height: 15,
              )
            ],
          ))),
    );
  }
}
