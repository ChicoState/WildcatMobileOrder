import 'package:WildcatMobileOrder/models/menu.dart';

class Cart {
  // map of MenuItem and a quantity
  Map<MenuItem, int> items;
  String location = '';
  int itemCount = 0;

  Cart() {
    itemCount = 0;
    location = '';
    items = Map<MenuItem, int>();
  }

  void setLocation(String newLocation) {
    this.location = newLocation;
    items.clear();
    itemCount = 0;
  }

  String getLocation() {
    return this.location;
  }

  bool checkLocation(String newLocation) {
    if (this.location == '') {
      setLocation(newLocation);
    }
    if (newLocation != this.location) {
      return false;
    }
    return true;
  }

  int getItemQuantity(MenuItem item) {
    return items[item];
  }


  // allows an item to be added to the cart
  bool addItem(MenuItem item, int quantity) {
    // if location differs from current cart, return false and don't add item
    if (!checkLocation(item.location)) {
      return false;
    }
    if (this.itemCount == 0) {
      this.location = item.location;
    }
    // if item already exists in map, just increment quantity
    if (this.items[item] != null) {
      this.items[item] += quantity;
      // if item doesn't exist, add entry
    } else {
      this.items[item] = quantity;
    }
    this.items.forEach((k, v) {
      print(k.name);
      print(v.toString());
      print(k.location);
    });
    this.itemCount += quantity;
    return true;
  }

  // changes the quantity selected
  void editQuantity(MenuItem item, int newQuantity) {
    // calculate difference in item count, and update
    this.itemCount += this.items[item] - newQuantity;
    this.items[item] = newQuantity;
    if (newQuantity == 0) {
      items.remove(item);
    }
  }

  // calculates an items price (price * quantity)
  double calcItemPrice(MenuItem item) {
    return item.price * this.items[item];
  }

  // calculates subtotal of entire cart
  double calcCartSubtotal() {
    double subtotal;
    this.items.forEach((k, v) {
      subtotal += calcItemPrice(k);
    });
    return subtotal;
  }
}