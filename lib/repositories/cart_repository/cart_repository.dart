import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

/// Allows access to Firebase to submit orders from cart
class CartRepository {
  /// Default constructor for CartRepository
  const CartRepository();

  /// Adds an order to Firebase
  Future<DocumentReference> addOrder(Cart currentCart, double price) async =>
      await Firestore.instance
          .collection('orders')
          .add(currentCart.toDocument(price));

  /// Queries for a user's order history (all previous orders)
  Future<QuerySnapshot> getOrderHistory(String user) async => Firestore.instance
      .collectionGroup('orders')
      .where('user', isEqualTo: user)
      .getDocuments();
}
