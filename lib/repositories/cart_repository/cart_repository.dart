import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

class CartRepository {
  const CartRepository();

  Future<DocumentReference> addOrder(Cart currentCart, double price) async =>
      await Firestore.instance
          .collection('orders')
          .add(currentCart.toDocument(price));

  Future<QuerySnapshot> getOrderHistory(String user) async => Firestore.instance
      .collectionGroup('orders')
      .where('user', isEqualTo: user)
      .getDocuments();
}
