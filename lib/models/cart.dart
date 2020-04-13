import 'package:WildcatMobileOrder/models/menu.dart';
import 'package:intl/intl.dart';

class Cart {
  List<CartItem> itemList;
  String location;
  int itemCount = 0;
  final currencyFormat = NumberFormat.simpleCurrency();

  Cart()
      : itemCount = 0,
        location = '',
        itemList = List<CartItem>();

  void setLocation(String newLocation) {
    this.location = newLocation;
    itemList.clear();
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

  // allows an item to be added to the cart
  bool addItem(MenuItem item, int quantity) {
    // if location differs from current cart, return false and don't add item
    if (!checkLocation(item.location)) {
      return false;
    }
    if (this.itemList.length == 0) {
      this.location = item.location;
    }
    if (this.itemList.contains(item)) {
      int idx =
          itemList.indexWhere((menuItem) => menuItem.item.name == item.name);
      itemList[idx].addOne();
    } else {
      itemList.add(CartItem.fromMenuItem(item, 1));
    }
    int newCount = 0;
    itemList.forEach((item) {
      newCount += item.quantity;
    });
    this.itemCount = newCount;
    return true;
  }

  // changes the quantity selected
  void editQuantity(CartItem item, int newQuantity) {
    int idx =
        itemList.indexWhere((cartItem) => cartItem.item.name == item.item.name);
    if (newQuantity == 0) {
      itemList.removeAt(idx);
    } else if (newQuantity > 0) {
      itemList[idx].quantity = newQuantity;
    } else {
      return;
    }
    int newCount = 0;
    itemList.forEach((item) {
      newCount += item.quantity;
    });
    this.itemCount = newCount;
  }

  void addOne(int idx) {
    itemList[idx].addOne();
  }

  void removeOne(int idx) {
    itemList[idx].removeOne();
    if (itemList[idx].quantity == 0) {
      itemList.removeAt(idx);
      if (itemList.length == 0) {
        this.location = '';
      }
    }
  }

  String getSubtotalPriceString() {
    return currencyFormat.format(this.calcCartSubtotal());
  }

  // calculates subtotal of entire cart
  double calcCartSubtotal() {
    double subtotal = 0;
    this.itemList.forEach((cartItem) {
      subtotal += cartItem.getItemPrice();
    });
    return subtotal;
  }
}

class CartItem {
  MenuItem item;
  int quantity;
  final currencyFormat = NumberFormat.simpleCurrency();

  CartItem.fromMenuItem(this.item, this.quantity);

  @override
  bool operator ==(dynamic other) {
    if (item.name == other.name && item.location == other.location) {
      return true;
    }
    return false;
  }

  @override
  int get hashCode => this.item.hashCode;

  void addOne() {
    quantity++;
  }

  void removeOne() {
    if (quantity > 0) {
      quantity--;
    }
  }

  double getItemPrice() {
    return item.price * quantity;
  }

  String getItemPriceString() {
    return currencyFormat.format(this.getItemPrice());
  }
}
