import 'package:WildcatMobileOrder/models/menu.dart';

class Cart {
  // map of MenuItem and a quantity
  Map<MenuItem, int> items;
  String location;

  Cart() {
    items = null;
    location = null;
    print('initializing cart');
  }

  void setLocation(String newLocation) {
    this.location = newLocation;
    items.clear();
  }

  bool checkLocation(String newLocation) {
    if (newLocation != this.location) {
      return false;
    }
    return true;
  }

  bool addItem(MenuItem item, int quantity) {
    // if location differs from current cart, return false and don't add item
    if (!checkLocation(item.location)) {
      return false;
    }
    if (this.items.containsKey(item)) {
      this.items[item] += quantity;
    } else {
      this.items[item] = quantity;
    }
    return true;
  }

  void editQuantity(MenuItem item, int newQuantity) {
    this.items[item] = newQuantity;
  }

  double calcItemPrice(MenuItem item) {
    return item.price * this.items[item];
  }

  double calcCartSubtotal() {
    double subtotal;
    this.items.forEach((k, v) {
      subtotal += calcItemPrice(k);
    });
    return subtotal;
  }
}