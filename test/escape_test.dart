import 'dart:convert';
import 'dart:io';

import 'package:escape/escape.dart';
import 'package:test/test.dart';

import '../bin/escape.dart';

void main() {
  final citiesFile = File("./cities.json");
  final data = citiesFile.readAsStringSync();
  final json = jsonDecode(data) as Map;
  final source = City.fromJson(json["BOM"]);
  final cities = {
    City.fromJson(json["BOM"]),
    City.fromJson(json["PAR"]),
    City.fromJson(json["CAI"]),
    City.fromJson(json["NYC"]),
    City.fromJson(json["BOG"]),
    City.fromJson(json["SYD"]),
  };
  final bonusMode = true;

  test('printShortestPathToVisitAllContinentFromSourceWithDistanceTravelled',
      () {
    printShortestPathToVisitAllContinentFromSourceWithDistanceTravelled(
      source,
      cities,
      !bonusMode,
    );
  });
}
