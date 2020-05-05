import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

class CartRepository {
  const CartRepository();

  Future<String> addOrder(Cart currentCart) async {
    DocumentReference order = await Firestore.instance
        .collection('orders')
        .add(currentCart.toDocument());
    return order.documentID;
  }
}
