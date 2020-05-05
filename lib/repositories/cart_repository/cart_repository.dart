import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

class CartRepository {
  const CartRepository();

  Future<DocumentReference> addOrder(Cart currentCart, double price) async {
    return await Firestore.instance
        .collection('orders')
        .add(currentCart.toDocument(price));
  }
}
