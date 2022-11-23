import 'package:flutter/cupertino.dart';

class CartModel with ChangeNotifier {
  final String id;
  final String title;
  final String price;

  int quantity;

  CartModel(
      {@required this.id,
      @required this.title,
      @required this.price,
      this.quantity = 1});
}

class CartCharges {
  final String id;
  final String price;

  final String name;
  final String quantity;

  CartCharges({
    @required this.id,
    @required this.price,
    @required this.name,
    @required this.quantity,
  });
}

class CartTotalProductModal with ChangeNotifier {
  final String id;
  final String title;
  final String price;
  final String priceincluds;

  final List<CartCharges> cartCharge;
  int quantity;

  CartTotalProductModal(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.priceincluds,
      @required this.cartCharge,
      this.quantity = 1});
}
// class DeliveryCharge{
//   final String productIds;
//   final String totalQuantity;
//   final String totalPrice;

//     DeliveryCharge({@required this.productIds,@required this.totalQuantity,@required this.totalPrice, 

//     });
// }
