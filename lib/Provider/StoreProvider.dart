import 'package:flutter/material.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/ModelClass/ModelRestaurantDetails.dart';

class StoreProvider extends ChangeNotifier {
  List<Subcategories> _cartItemList = [];
  List<Subcategories> get cartItemList => _cartItemList;
  var storedRestaurantID = '';
  var restaurantDetails = ResDetails();
  bool isSearchAddress = false;
  Subcategories productData;

  removeItemFromCart(Subcategories item) {
    Subcategories found =
        _cartItemList.firstWhere((p) => p.id == item.id, orElse: () => null);
    print("Founded item object:-${found.name}");

    if (found != null && found.count == 1) {
      //First change value from the main objecct
      for (var cate in this.restaurantDetails.categories) {
        for (var myItem in cate.subcategories) {
          if (item.id == myItem.id) {
            myItem.isAdded = false;
          }
        }
      }

      _cartItemList.removeWhere((element) => element.id == found.id);
    }
    if (found != null && found.count > 1) {
      found.count -= 1;
    }
    print("Cart item after removing:->${_cartItemList.length}");
    if (_cartItemList.length == 0) {
      this.storedRestaurantID = '';
    }
    notifyListeners();
  }

  addItemTocart(Subcategories item, String resId, BuildContext context) {
    if (this.storedRestaurantID != resId) {
      this._cartItemList = [];
      if (this.storedRestaurantID != '') {
        SharedManager.shared
            .showAlertDialog('Old items deleted from the cart', context);
      }
      this.storedRestaurantID = resId;
    }

    Subcategories subCat =
        _cartItemList.firstWhere((p) => p.id == item.id, orElse: () => null);
    if (subCat != null) {
      print("Item Count:${subCat.count}");
      subCat.count += 1;
    } else {
      _cartItemList.add(item);
      //First change value from the main objecct
      for (var cate in this.restaurantDetails.categories) {
        for (var myItem in cate.subcategories) {
          if (item.id == myItem.id) {
            myItem.isAdded = true;
          }
        }
      }
      // item.count += 1;
    }

    print("Cart item after Adding:->${_cartItemList.length}");
    notifyListeners();
  }

  int getTotalCartCount() {
    return _cartItemList.length;
  }

  double getTotalPrice() {
    var price = 0.0;
    for (var item in this._cartItemList) {
      {
        price =
            price + (double.parse(item.price) - double.parse(item.discount));
        // SharedManager.shared.cartItems.add(item);
      }
    }
    return price;
  }

  void clearCartList() {
    _cartItemList = [];
  }
}
