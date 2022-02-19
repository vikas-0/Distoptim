import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dist_guesser_application/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

var buttonStyle = ElevatedButton.styleFrom(
  elevation: 10,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
  minimumSize: const Size(300, 60),
);

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);
  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreen();
}

class _LeaderBoardScreen extends State<LeaderBoardScreen>
    with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Local'),
    Tab(text: 'Global'),
  ];

  late TabController _tabController;
  late ScoreList localList = ScoreList();
  late ScoreList globalList = ScoreList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    final storage = LocalStorage('score_data.json');
    storage.ready.then((_) {
      var i = storage.getItem('score_list') ?? [];

      if (i is List) {
        localList.fromJson(i);
        localList.items.sort((a, b) => b.score.compareTo(a.score));
        setState(() {});
      }
    });

    FirebaseFirestore.instance
        .collection('scores-new')
        .orderBy('score', descending: true)
        .limit(100)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var s =
            ScoreItem(name: element.get('name'), score: element.get('score'));
        globalList.items.add(s);
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeaderBoard'),
        backgroundColor: Colors.black26,
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          final String label = tab.text!.toLowerCase();
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              showBottomBorder: true,
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Score'))
              ],
              rows: (label == 'local' ? localList : globalList)
                  .items
                  .map<DataRow>((ScoreItem item) => DataRow(
                        cells: [
                          DataCell(Text(item.name)),
                          DataCell(Text(item.score.toString()))
                        ],
                      ))
                  .toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
