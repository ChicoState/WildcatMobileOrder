import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories.dart';

class MenuRepository {
  final Firestore firestore = Firestore.instance;

  Stream<List<MenuEntity>> getMenus() => firestore
      .collection('menus')
      .snapshots()
      .map((snapshots) => snapshots.documents
          .map((snapshot) => MenuEntity.fromSnapshot(snapshot))
          .toList());
}
