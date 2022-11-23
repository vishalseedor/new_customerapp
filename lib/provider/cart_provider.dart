import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:food_app/const/image_base64.dart';
import 'package:food_app/models/cart.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/provider/shareprefes_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../const/config.dart';
import '../services/snackbar.dart';

class CartProvider with ChangeNotifier {
  bool _isLoading = false;

  GlobalSnackBar globalSnackBar = GlobalSnackBar();

  bool get isLoading {
    return _isLoading;
  }

  List<CartModel> _cartproduct = [];
  List<CartModel> get cartproduct {
    return [..._cartproduct];
  }

  List<int> _prodId = [];
  List<int> get prodId {
    return _prodId;
  }

  List<CartTotalProductModal> _carttotalProductData = [];

  List<CartTotalProductModal> get cartTotalProductdata {
    return _carttotalProductData;
  }

  void clearcartTotalProductdata() {
    _carttotalProductData.clear();
    notifyListeners();
  }

  List<int> cartQuantity = [];
  List<String> cartProductids = [];
  List<String> cartProductname = [];
  List<String> cartPrice = [];
  List<String> priceInclude = [];
  int productTemplateId;
  List<List<CartCharges>> totalCartProductcharge = [];
  List<CartCharges> cartCharges = [];
  String deliverycharge = '0.0';

  // List<DeliveryCharge>_deliverycharge=[];

  // List<DeliveryCharge>get deliverycharge{
  //   return _deliverycharge;
  // }
  List<String> productIds = [];
  List<String> totalQuantity = [];
  List<String> totalPrice = [];

  // Future getAllCartProduct({List<int> prodId}) async {
  //   try {
  //     // Map<String, Favourite> loadData = {};
  //     List<CartModel> loadData = [];
  //     var headers = {
  //       'Content-Type': 'application/json',
  //     };

  //     var body = json.encode({
  //       "product_ids": prodId,
  //     });
  //     print(body + 'cart body');
  //     var response = await http.post(
  //         Uri.parse(
  //             'http://eiuat.seedors.com:8290/customer-mobile-app/get-product/$client_id'),
  //         headers: headers,
  //         body: body);
  //     var jsonData = await json.decode(response.body);
  //     print('cart started ');
  //     print('cart value' + jsonData.toString());
  //     if (response.statusCode == 200) {
  //       for (var i = 0; i < jsonData.length; i++) {
  //         final base64 = jsonData[i]['image_1024'] == ''
  //             ? customBase64
  //             : jsonData[i]['image_1024'];
  //         var image = base64Decode(base64);
  //         print(jsonData[i]['id']);
  //         print(jsonData[i]['display_name']);
  //         print(jsonData[i]['price']);
  //         print(jsonData[i]['image_1024']);
  //         loadData.add(CartModel(
  //             id: jsonData[i]['id'].toString(),
  //             title: jsonData[i]['display_name'].toString(),
  //             price: jsonData[i]['price'],
  //             imageUrl: image,
  //             quantity: 1));
  //         // loadData.
  //         // ignore: missing_return
  //         // _favourite.putIfAbsent('', () {
  //         //   Favourite(
  //         // id: jsonData[i]['create_uid'][0].toString(),
  //         // productTitle: jsonData[i]['display_name'].toString(),
  //         // productPrice: jsonData[i]['cart_qty'],
  //         // imageUrl: jsonData[i]['image_1024'],
  //         // productCategory: jsonData[i]['categ_id'][1]);
  //         //   notifyListeners();
  //         //   print('fav product ' + _favourite.toString());
  //         // });
  //         // loadData.putIfAbsent('32', () {
  //         //   print('welcome');

  //         //   // Favourite(
  //         //   //     id: jsonData[i]['create_uid'][0].toString(),
  //         //   //     productTitle: jsonData[i]['display_name'].toString(),
  //         //   //     productPrice: jsonData[i]['cart_qty'],
  //         //   //     imageUrl: jsonData[i]['image_1024'],
  //         //   //     productCategory: jsonData[i]['categ_id'][1]);
  //         // });

  //         print('simple' + loadData.toString());
  //       }
  //       _cartproduct = loadData;
  //       print(_cartproduct.length.toString() + 'fav data length');
  //       notifyListeners();
  //       print('kkkkkkk' + loadData.toString());
  //     } else {
  //       print(response.reasonPhrase);
  //     }
  //   } catch (e) {
  //     print('error ---->>' + e.toString());
  //   }
  // }

  Future cartProductId({BuildContext context}) async {
    // final product = Provider.of<ProductProvider>(context, listen: false);
    try {
      _isLoading = true;

      List<CartModel> loadData = [];
      List<int> id = [];
      print('runing runing runiing');

      final data = Provider.of<UserDetails>(context, listen: false);

      data.getAllDetails();

      var response = await http.get(
        Uri.parse(
            'http://eiuat.seedors.com:8290/customer-app/mycart/${data.id}?clientid=$client_id&status=cart'),
      );
      print(
          'http://eiuat.seedors.com:8290/customer-app/mycart/${data.id}?clientid=$client_id&status=cart');

      if (response.statusCode == 200) {
        print('No product');
        var jsonData = json.decode(response.body);
        if (jsonData['entries'].toString() != '{}') {
          // var
          // print(response.body);
          print('cart product 200');
          for (var i = 0; i < jsonData['entries']['entry'].length; i++) {
            var data = int.parse(jsonData['entries']['entry'][i]['quantity']);
            var price =
                jsonData['entries']['entry'][i]['list_price'].toString() == ""
                    ? '0'
                    : jsonData['entries']['entry'][i]['list_price'].toString();
            // print('welcome cart' + jsonData['entries']['entry'][i].toString());
            // print(jsonData['entries']['entry'][i]['productid']);
            // id.add(int.parse(jsonData['entries']['entry'][i]['productid']));
            // print('product id + ${id[i]}');
            if (data >= 1) {
              id.add(int.parse(jsonData['entries']['entry'][i]['productid']));

              loadData.add(CartModel(
                  id: jsonData['entries']['entry'][i]['productid'].toString(),
                  title: jsonData['entries']['entry'][i]['product_variant_id']
                      .toString(),
                  price: price,
                  quantity: data));
              cartQuantity.add(data);
              // _prodId = jsonData['entries']['entry'][i]['productid'];

              print('cart product id final' + loadData.toList().toString());
            }
          }
          _cartproduct = loadData;
          _prodId = id;
          _isLoading = false;
          print('completed cart loading --->>');
          print(_cartproduct.length.toString() +
              'completed cart loading --->> length');
          notifyListeners();
          // await getAllCartProduct(prodId: _prodId);
        } else {
          _prodId = [];
          // await getAllProductFavApi(_prodId);
          _isLoading = false;
          print('completed cart loading --->>');
          notifyListeners();
        }
      } else {
        _isLoading = false;
        print('completed cart loading --->>');
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
      _isLoading = false;
      print('completed cart loading --->>');
      notifyListeners();
      print('Something went wrong jjdhjdgj welcome welcome');
    }
  }

  Future<String> cartProductPost({
    BuildContext context,
    String productId,
    int quantity,
  }) async {
    String statesCodec = '0';
    try {
      final data = Provider.of<UserDetails>(context, listen: false);
      data.getAllDetails();
      var headers = {
        'Content-Type': 'application/json',
      };
      print(dateTimeNow);
      print(productId);
      var body = json.encode({
        "userid": data.id,
        "clientid": client_id,
        "productid": productId,
        "status": cartStatus,
        "created_date": dateTimeNow,
        "quantity": quantity
      });
      print(body);
      var response = await http.post(
          Uri.parse('http://eiuat.seedors.com:8290/customer-app/addtocart'),
          headers: headers,
          body: body);
      print('http://eiuat.seedors.com:8290/customer-app/addtocart' + 'cart');

      statesCodec = response.statusCode.toString();
      var jsonData = json.decode(response.body);
      print(jsonData);
      statesCodec = jsonData['code'];
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 202) {
        print(response.body);
        print('successfully post');
      } else {
        print(response.reasonPhrase);
      }
      print(statesCodec.toString() + 'Status code 2');
      print(response.statusCode.toString() + 'Status code 2');
      return response.statusCode.toString();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteCart({
    @required String prodId,
    @required BuildContext context,
    @required int index,
  }) async {
    try {
      final user = Provider.of<UserDetails>(context, listen: false);

      user.getAllDetails();
      var headers = {
        'Content-Type': 'application/json',
      };
      var body = json.encode({
        "productid": prodId,
        "userid": user.id,
        "clientid": client_id,
        "status": cartStatus,
      });
      print(body);
      var response = await http.delete(
        Uri.parse('http://eiuat.seedors.com:8290/customer-app/remove-cart'),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 202) {
        _cartproduct.removeAt(index);
        _carttotalProductData.removeAt(index);

        notifyListeners();
        globalSnackBar.generalSnackbar(
            context: context, text: 'Deleted Successfull');
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  // int get productquantity {
  //   var qua = 0;
  //   _cartproduct.
  // }
  Future<void> removeAllCartProd({BuildContext context}) async {
    try {
      var data = Provider.of<UserDetails>(context, listen: false);
      final product = Provider.of<ProductProvider>(context, listen: false);
      data.getAllDetails();
      var header = {
        'Content-Type': 'application/json',
      };
      var body = json.encode({
        "userid": data.id.toString(),
        "clientid": client_id,
        "status": "cart"
      });
      print(body);
      var response = await http.delete(
          Uri.parse('http://eiuat.seedors.com:8290/customer-app/clear-cart'),
          body: body,
          headers: header);
      if (response.statusCode == 202) {
        globalSnackBar.generalSnackbar(
            context: context, text: 'Your cart is clear');
        product.clearcartcount();
        _cartproduct.clear();
        _carttotalProductData.clear();

        notifyListeners();
      } else {
        globalSnackBar.generalSnackbar(
            context: context, text: 'Something went wrong');
      }
    } catch (e) {
      print(e.toString());
      // globalSnackBar.generalSnackbar(
      //     context: context, text: 'Something went wrong');
    }
  }

  void cartIconButtton({@required BuildContext context}) {
    // var data = Provider.of<FavouriteProvider>(context, listen: false).fav;
    final cart = Provider.of<CartProvider>(context, listen: false);
    // print('fav product lemngth ${data.length}');
    final product =
        Provider.of<ProductProvider>(context, listen: false).product;

    if (cart.cartproduct.isNotEmpty) {
      for (var i = 0; i < product.length; i++) {
        print(product.length.toString() + 'product length');
        for (var j = 0; j < cart.cartproduct.length; j++) {
          print(cart.cartproduct.length.toString() + 'cart length');

          if (product[i].productId == cart.cartproduct[j].id) {
            print(cart.cartproduct[j].toString() +
                '  Cart product is true  ' +
                product[i].productId);
            product[i].isCart = true;
          } else {
            print('Fav product is false' + product[i].productId);

            // product[i].isFavourite = false;
          }
        }
      }
    } else if (cart.cartproduct.isEmpty) {
      print('data empty in favourite');
      for (var i = 0; i < product.length; i++) {
        product[i].isCart = false;
      }
    }
  }

  double get totalAmount {
    double total = 0.0;
    for (var i = 0; i < _carttotalProductData.length; i++) {
      total += double.parse(_carttotalProductData[i].price) *
          (_cartproduct[i].quantity);
    }
    return total.roundToDouble();
  }

  double get alltotaladditionalcharge {
    double charge = 0.0;
    for (var i = 0; i < _carttotalProductData.length; i++) {
      for (var j = 0; j < cartTotalProductdata[i].cartCharge.length; j++) {
        if (cartTotalProductdata[i].cartCharge[j].price == '' ||
            cartTotalProductdata[i].cartCharge[j].price == null) {
        } else {
          charge += double.parse(cartTotalProductdata[i].cartCharge[j].price) *
              cartproduct[i].quantity;
        }
      }
    }
    print(charge.roundToDouble().toString() + 'total additinal charge data');
    return charge.roundToDouble();
  }

  //    }
  // for (var value in _cartproduct) {
  //   total += double.parse(value.price) * value.quantity;
  //   print(total.toString() + 'total amopunt');
  // }

  // _cartproduct.forEach((key, value) {
  //   total += value.price * value.quantity;
  // });

  double get shippingcharge {
    var shipping = 0.0;
    var charge = 0.0;
    for (var value in _cartproduct) {
      shipping += double.parse(value.price) * value.quantity;
    }
    // _cartproduct.forEach((key, value) {
    //   shipping += value.price * value.quantity;
    // });
    if (shipping > 500) {
      charge = 0;
    } else if (shipping < 500) {
      charge = 50;
    }

    return charge.roundToDouble();
  }

  double get totalTax {
    var tax = 0.0;
    var total = 0.0;
    for (var value in _carttotalProductData) {
      total += double.parse(value.price) * value.quantity;
      tax = ((total / 100) * 8).toDouble();
    }
    // _carttotalProductData.forEach((key, value) {
    //   total += value.price * value.quantity;
    //   tax = ((total / 100) * 8).toInt();
    // });

    return tax.toDouble();
  }

  String get totalprice {
    double totalCast = 0.0;
    totalCast =
        totalAmount + alltotaladditionalcharge + double.parse(deliverycharge);

    // print('success total' + totalCast.toString());

    return totalCast.round().toString();
  }

  double get vattax {
    var vat = 0.0;
    var amount = 0.0;
    var percentage = 8.0;
    for (var value in _carttotalProductData) {
      amount += double.parse(value.price) * value.quantity;
    }
    // _cartproduct.forEach((key, value) {
    //   amount += value.price * value.quantity;
    // });
    vat = (amount + (percentage / 100) * amount);

    return vat;
  }

  void addToCart(
      {@required String id,
      // @required String title,
      // @required double price,
      // @required int index,
      // @required Uint8List imageUrl,
      @required int quantity,
      String title,
      int imageUrl}) {
    _cartproduct.indexWhere((element) => element.id == id);
    quantity + 1;
    notifyListeners();
  }

  void decreaseCount(
      {@required String id,
      @required String title,
      @required double price,
      @required Uint8List imageUrl,
      @required int quantity}) {
    if (_cartproduct.contains(id)) {
      // _cartproduct.update(
      //     id,
      //     (existingCart) => CartModel(
      //         id: existingCart.id,
      //         title: existingCart.title,
      //         price: existingCart.price,
      //         imageUrl: existingCart.imageUrl,
      //         quantity: existingCart.quantity - 1));
    }
    notifyListeners();
  }

  // void removeCart(
  //     {@required int index,
  //     @required String productId,
  //     BuildContext context}) async {
  //   _cartproduct.removeAt(index);
  //   await deleteCart(prodId: productId, context: context);
  //   notifyListeners();
  // }

  // void clear({BuildContext context}) {
  //   _cartproduct.clear();
  //   Provider.of<CartProvider>(context, listen: false)
  //       .removeAllCartProd(context: context);
  //   notifyListeners();
  // }

  void addCartProductIntoggle(@required String id, @required String title,
      @required double price, @required int quantity) {
    final newAddItem = CartModel(
        id: id, title: title, price: price.toString(), quantity: quantity + 1);
    if (_cartproduct.isNotEmpty) {
      bool isFound = false;
      for (int itemcount = 0; itemcount < _cartproduct.length; itemcount++) {
        if (_cartproduct[itemcount].id == newAddItem.id) {
          print("addCard");
          isFound = true;
          _cartproduct[itemcount].quantity + 1;
          notifyListeners();
          break;
        }
      }
      if (!isFound) {
        _cartproduct.add(newAddItem);
        notifyListeners();
      }
    } else {
      _cartproduct.add(newAddItem);
      notifyListeners();
    }
  }

  Future testCartProductIds({BuildContext context}) async {
    final product = Provider.of<ProductProvider>(context, listen: false);
    try {
      _isLoading = true;

      List<CartModel> loadData = [];
      totalCartProductcharge = [];
      cartCharges = [];
      List<int> id = [];
      notifyListeners();
      print('runing runing runiing');

      final data = Provider.of<UserDetails>(context, listen: false);

      data.getAllDetails();

      var response = await http.get(
        Uri.parse(
            'http://eiuat.seedors.com:8290/customer-app/mycart/${data.id}?clientid=$client_id&status=cart'),
      );
      print(
          'http://eiuat.seedors.com:8290/customer-app/mycart/${data.id}?clientid=$client_id&status=cart');

      if (response.statusCode == 200) {
        print('No product');
        var jsonData = json.decode(response.body);
        if (jsonData['entries'].toString() != '{}') {
          // var
          // print(response.body);
          print('cart product 200');
          for (var i = 0; i < jsonData['entries']['entry'].length; i++) {
            var data = int.parse(jsonData['entries']['entry'][i]['quantity']);
            var price =
                jsonData['entries']['entry'][i]['list_price'].toString() == ""
                    ? '0'
                    : jsonData['entries']['entry'][i]['list_price'].toString();
            // print('welcome cart' + jsonData['entries']['entry'][i].toString());
            //[1107, 1068, 1105, 1093, 1111, 1073, 1076]
            // print(jsonData['entries']['entry'][i]['productid']);
            // id.add(int.parse(jsonData['entries']['entry'][i]['productid']));
            // print('product id + ${id[i]}');
            id.add(int.parse(jsonData['entries']['entry'][i]['productid']));
            print(id.toList().toString() + 'cart product id list');
            if (data >= 1) {
              cartQuantity.add(data);
              // loadData.add(CartModel(
              //     id: jsonData['entries']['entry'][i]['productid'].toString(),
              //     title: jsonData['entries']['entry'][i]['product_variant_id']
              //         .toString(),
              //     price: price,
              //     quantity: data));
              // cartQuantity.add(data);
              // _prodId = jsonData['entries']['entry'][i]['productid'];

              print('cart product id final' + loadData.toList().toString());
            }
          }
          await getproductdetailsWithId(productIds: id);
          // _cartproduct = loadData;
          // _prodId = id;
          _isLoading = false;
          print('completed cart loading --->>');
          notifyListeners();
          // await getAllCartProduct(prodId: _prodId);
        } else {
          _prodId = [];
          // await getAllProductFavApi(_prodId);
          _isLoading = false;
          print('completed cart loading --->>');
          notifyListeners();
        }
      } else {
        _isLoading = false;
        print('completed cart loading --->>');
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
      _isLoading = false;
      print('completed cart loading --->>');
      notifyListeners();
      print('Something went wrong jjdhjdgj welcome welcome');
    }
  }

  Future getproductdetailsWithId({@required List<int> productIds}) async {
    print('product get working good --->> 1');
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Cookie':
          'session_id=d798a1308109711d1021e60acdb94a7a97b883f6; session_id=c22bd3a7ad602282606e9f011f23b1f8276098e3'
    };
    var body = json.encode({
      "clientid": "bookseedorpremiumuat",
      "type": "products",
      "fields":
          "{'id','standard_price_tax_included','display_name','product_tmpl_id','price_included'}",
      "domain": "[('categ_id','!=','Seedor Products'),('id','=',$productIds)]"
    });
    print(body.toString() + 'product get api with ids');
    print('product get working good --->> 2');
    var response = await http.post(
        Uri.parse('http://eiuat.seedors.com:8290/get-all-details'),
        headers: headers,
        body: body);

    var jsondata = json.decode(response.body);
    print('product get working good --->> 3');
    if (response.statusCode == 200) {
      _carttotalProductData = [];
      cartProductids = [];
      cartPrice = [];
      priceInclude = [];
      cartProductname = [];
      productTemplateId;
      for (var i = 0; i < jsondata.length; i++) {
        cartProductids.add(jsondata[i]['id'].toString());
        cartPrice.add(jsondata[i]['standard_price_tax_included'].toString());
        priceInclude.add(jsondata[i]['price_included'].toString());
        cartProductname.add(jsondata[i]['display_name'].toString());
        productTemplateId = jsondata[i]['product_tmpl_id'][0];
        await getDeliveryCharge(ids: jsondata[i]['product_tmpl_id'][0]);
      }
      print('product get working good --->> 4');

      notifyListeners();
    } else {
      print(response.reasonPhrase);
      print('product get working good--->>5');
    }
  }

  Future getDeliveryCharge({@required int ids}) async {
    print('delivery get working good --->> 1');
    var headers = {
      'Cookie':
          'session_id=a741255f42ab8838c1caab05a8d61296643ff3e1; session_id=22b75295c1223dc4f1dc90638d3bc6aecaeb2780'
    };
    var response = await http.get(
        Uri.parse(
            "http://eiuat.seedors.com:8290/seedor-api/charge/additional-charge?clientid=bookseedorpremiumuat&fields={'name','bi_product_template','price','product_id'}&variantids=[('bi_product_template','=',[$ids])]"),
        headers: headers);

    print('delivery get working good --->> 2');
    print(response.statusCode.toString() + 'delivery get working good 123');

    var jsondata = json.decode(response.body);
    print(jsondata);
    if (response.statusCode == 200) {
      print('delivery get working good --->> 3');
      print(jsondata.isEmpty.toString() + 'is empty');
      if (jsondata.isEmpty) {
        print('loop is not working working');
        cartCharges.add(CartCharges(id: '', price: '', name: 'summa'));
        totalCartProductcharge.add(cartCharges);
        print('--->>> dot' + totalCartProductcharge[0].toList().toString());
        cartCharges = [];
      } else {
        print('loop is working working');
        cartCharges = [];

        for (var i = 0; i < jsondata.length; i++) {
          cartCharges.add(CartCharges(
              id: jsondata[i]['product_id'][0].toString(),
              price: jsondata[i]['price'].toString(),
              name: jsondata[i]['name'].toString()));
          totalCartProductcharge.add(cartCharges);
        }
      }
      print('delivery get working good --->> 4');
      notifyListeners();
    } else {
      print(response.reasonPhrase);
    }
  }

  bool _deliveryLoading = false;
  bool get deliveryLoading {
    return _deliveryLoading;
  }

  Future finalDeliveryCharge(
      {@required String productIds,
      @required String totalQuantity,
      @required String totalPrice,
      BuildContext context}) async {
    try {
      var headers = {
        'Cookie': 'session_id=90c888fe92399e1aaface6c5f6ab399d2b6e4e2d'
      };
      _deliveryLoading = true;
      var response = await http.get(
          Uri.parse(
              'http://eiuat.seedors.com:8290/seedor-api/charge/delivery-charge?clientid=bookseedorpremiumuat&product_ids=$productIds&total_quantity=$totalQuantity&total_price=$totalprice'),
          headers: headers);
      print(
          'http://eiuat.seedors.com:8290/seedor-api/charge/delivery-charge?clientid=bookseedorpremiumuat&product_ids=$productIds&total_quantity=$totalQuantity&total_price=$totalprice');

      var jsondata = json.decode(response.body);

      print(jsondata);
      if (response.statusCode == 200) {
        deliverycharge = '0.0';

        deliverycharge = jsondata['delivery_charge'][0].toString();

        print(deliverycharge);

        print('final delivery charge working successfully');
        _deliveryLoading = false;
      } else {
        print(response.reasonPhrase);
        _deliveryLoading = false;
      }
    } catch (e) {
      _deliveryLoading = false;
      print('final delivery charge is working correctly');
    }
  }

  Future<void> totalCartData() async {
    for (var i = 0; i < prodId.length; i++) {
      _carttotalProductData.add(CartTotalProductModal(
          id: cartProductids[i].toString(),
          title: cartProductname[i].toString(),
          price: cartPrice[i].toString(),
          cartCharge: totalCartProductcharge[i].toSet().toList()));

      print(
          _carttotalProductData.length.toString() + 'vanthuru da vanthuruuuu');
      print(_carttotalProductData[i].cartCharge.length.toString() +
          'vanthuru da vanthuruuuu cart charge');
    }
  }
}
