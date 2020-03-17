import 'package:cloud_firestore/cloud_firestore.dart';

/// Holds a list of all locations, and their meta data.
class Locations {
  List<LocationItem> locations;

  Locations.fromSnapshot(DocumentSnapshot snapshot)
      : locations = snapshot['meta'].map<LocationItem>((loc) {
    return LocationItem.fromMap(loc);
  }).toList();
}

/// Represents a single location
class LocationItem {
  final String openTime;
  final String closeTime;
  final String name;

  LocationItem.fromMap(Map<String, dynamic> map)
      : openTime = map['opentime'],
        closeTime = map['closetime'],
        name = map['name'];

  String getOpenHours() {
    return 'Opens at $openTime and closes at $closeTime';
  }

  String getOrderString() {
    return 'Order from $name';
  }
}