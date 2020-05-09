import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';

class MenuRepository {
  final Firestore firestore = Firestore.instance;

  Stream<List<MenuEntity>> getMenus() {
    return firestore.collection('menus').snapshots().map((snapshots) {
      return snapshots.documents.map((snapshot) {
        return MenuEntity.fromSnapshot(snapshot);
      }).toList();
    });
  }
}
