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
  int openTime;
  int openMin;
  int closeTime;
  int closeMin;
  final String name;

  LocationItem.fromMap(Map<String, dynamic> map)
      : openTime = map['opentime'],
        openMin = map['openMin'],
        closeTime = map['closetime'],
        closeMin = map['closeMin'],
        name = map['name'];

  String getOpenHours() { 
    String frmtSpcng = "               ";
    String printOpen = "$openTime:$openMin AM";
    String printClose;
  
    if (closeTime > 12) {
      closeTime = closeTime - 12;
      printClose = "$closeTime:$closeMin PM";
    }
    else {
      printClose = "$closeTime:$closeMin PM";
    } 
    return '  Hours: \n $frmtSpcng $printOpen - $printClose';
  }

  String isOpen () {
    var curDate = new DateTime.now();
    int curHr = curDate.hour;
    int curMin = curDate.minute;
    String res = "OPEN";
    if ( (curHr > closeTime) && (curMin > closeMin) ) {
      res = "CLOSED";
    }

    if ( (curHr < openTime) && (curMin < openMin) ) {
      res = "CLOSED";
    }
    return ' is $res';
  }

  String getOrderString() {
    return 'Order from $name';
  }
}
