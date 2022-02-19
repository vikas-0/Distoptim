import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'dart:math' show cos, sqrt, asin;

class City {
  final String name;
  final String state;
  final double latitiude;
  final double longitude;
  const City(this.name, this.state, this.latitiude, this.longitude);
}

Future<Iterable<City>> loadData() async {
  final mydata = await rootBundle.loadString('assets/in.csv');
  List<List<dynamic>> csvTable = const CsvToListConverter().convert(mydata);
  return csvTable.sublist(1).map((e) => City(e[0], e[5], e[1], e[2]));
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

class ScoreItem {
  String name;
  int score;

  ScoreItem({required this.name, required this.score});

  ScoreItem.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          score: json['score']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'score': score,
    };
  }

  toJSONEncodable() {
    Map<String, dynamic> m = {};

    m['name'] = name;
    m['score'] = score;

    return m;
  }
}

class ScoreList {
  List<ScoreItem> items = [];

  fromJson(List<dynamic> json) {
    items =
        json.map((e) => ScoreItem(name: e['name'], score: e['score'])).toList();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

final scoreRef = FirebaseFirestore.instance
    .collection('scores-new')
    .withConverter<ScoreItem>(
        fromFirestore: (snapshot, _) => ScoreItem.fromJson(snapshot.data()!),
        toFirestore: (score, _) => score.toJson());
