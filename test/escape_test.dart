import 'dart:convert';
import 'dart:io';

import 'package:escape/escape.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
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
  final bonusMode = false;

  test('printShortestPathToVisitAllContinentFromSourceWithDistanceTravelled',
      () {
    final allCities = [
      ...cities.toList(),
      source,
    ];
    var totalDistance = 0.0;
    for (var i = 0; i < allCities.length; i++) {
      if (allCities.length == i + 1) {
        break;
      }
      final currentCity = allCities[i];
      final nextCity = allCities[i + 1];
      totalDistance += SphericalUtil.computeDistanceBetween(
        LatLng(
          currentCity.location.lat,
          currentCity.location.lon,
        ),
        LatLng(
          nextCity.location.lat,
          nextCity.location.lon,
        ),
      );
    }
    print("${totalDistance / 1000}");
  });
}
