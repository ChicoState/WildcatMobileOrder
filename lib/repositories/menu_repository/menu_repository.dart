import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories.dart';

/// Repository to provide for access and updates to menu/location information
class MenuRepository {
  /// Firestore instance to access data
  final Firestore firestore = Firestore.instance;

  /// Returns a list of Menu objects
  Stream<List<Menu>> getMenus() => firestore
      .collection('menus')
      .snapshots()
      .map((snapshots) => snapshots.documents
          .map((snapshot) => Menu.fromSnapshot(snapshot))
          .toList());
}
