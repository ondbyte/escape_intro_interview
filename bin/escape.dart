import 'dart:convert';
import 'dart:io';

import 'package:escape/escape.dart' as escape;
import 'package:maps_toolkit/maps_toolkit.dart';

void main(List<String> arguments) {
  if (arguments.length < 2) {
    throw Exception(
      "Please input cities file path as arg 1 and id of the city to start as arg 2, optional 'true' as third argument if you need to switch to bonus mode (maximze travel distance)",
    );
  }
  final citiesFilePath = arguments[0];
  final citiesFile = File(citiesFilePath);
  if (!citiesFile.existsSync()) {
    throw Exception("Cannot read cities file");
  }
  final data = citiesFile.readAsStringSync();
  final json = jsonDecode(data) as Map;
  final cities = json.values.map((value) => City.fromJson(value)).toSet();
  final source = City.fromJson(json[arguments[1]]);
  final bonusMode = arguments.length == 3 && arguments[2] == 'true';

  printShortestPathToVisitAllContinentFromSourceWithDistanceTravelled(
    source,
    cities,
    !bonusMode,
  );
}

void printShortestPathToVisitAllContinentFromSourceWithDistanceTravelled(
  City source,
  Set<City> cities,
  bool closest,
) {
  var currentCity = source;
  final path = <City>{};
  var distanceTravelledInMeters = 0.0;

  //from source to all other continent
  while (() {
    cities.removeWhere((e) => e.contId == currentCity.contId);
    return cities.isNotEmpty;
  }()) {
    path.add(currentCity);
    final closestCityWithDistance = _getClosestOrFarthestCityWithDistace(
      currentCity,
      cities,
      closest,
    );
    currentCity = closestCityWithDistance.city;
    distanceTravelledInMeters += closestCityWithDistance.distance;
  }

  //from last continent to source continent

  final closestCityWithDistance = _getClosestOrFarthestCityWithDistace(
    currentCity,
    {source},
    closest,
  );
  distanceTravelledInMeters += closestCityWithDistance.distance;

  //output all cities in order of visit with distance
  print((path.map((e) => e.id + "(${e.name})").toList()
        ..add(source.id + "(${source.name})"))
      .join("-->"));
  print("Distance travelled in KMs ${distanceTravelledInMeters / 1000}");
}

///returns closest city in the [cities] set to the [city] and its distance
CityWithDistance _getClosestOrFarthestCityWithDistace(
  City city,
  Set<City> cities,
  bool closest,
) {
  City? lastCity;
  num lastDistance = closest ? double.infinity : double.negativeInfinity;
  for (var item in cities) {
    final distance = SphericalUtil.computeDistanceBetween(
      LatLng(city.location.lat, city.location.lon),
      LatLng(
        item.location.lat,
        item.location.lon,
      ),
    );
    if (closest) {
      if (distance < lastDistance) {
        lastDistance = distance;
        lastCity = item;
      }
    } else {
      if (distance > lastDistance) {
        lastDistance = distance;
        lastCity = item;
      }
    }
  }
  return CityWithDistance(lastCity!, lastDistance);
}

class CityWithDistance {
  final City city;
  final num distance;

  CityWithDistance(this.city, this.distance);
}

class City {
  City({
    required this.id,
    required this.name,
    required this.location,
    required this.countryName,
    required this.contId,
  });

  String id;
  String name;
  Location location;
  String countryName;
  String contId;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        location: Location.fromJson(json["location"]),
        countryName: json["countryName"],
        contId: json["contId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location.toJson(),
        "countryName": countryName,
        "contId": contId,
      };
}

class Location {
  Location({
    required this.lat,
    required this.lon,
  });

  double lat;
  double lon;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
      };
}
