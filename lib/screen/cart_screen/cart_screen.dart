import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:food_app/const/theme.dart';

import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/screen/cart_screen/cart_errormessage_screen.dart';
import 'package:food_app/screen/cart_screen/empty_cart_screen.dart';
import 'package:food_app/widget/cart_product_wid/cart_full_design.dart';

import 'package:provider/provider.dart';

import '../../const/color_const.dart';
import '../../provider/product_provider.dart';

class MyCartScreen extends StatefulWidget {
  final String productId;
  final List value;

  const MyCartScreen({Key key, @required this.productId, @required this.value})
      : super(key: key);
  static const routeName = 'mycart_screen';

  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  bool isLoading = false;
  bool isError = false;
  @override
  void initState() {
    super.initState();
    final data = Provider.of<CartProvider>(context, listen: false);
    // data.clearcartTotalProductdata();
    setState(() {
      isLoading = true;
      isError = false;
    });

    Provider.of<CartProvider>(context, listen: false)
        .cartProductId(context: context);

    data.testCartProductIds(context: context).then((value) {
      data.totalCartData().then((value) {
        int quantity = 0;
        List<String> prodId = [];
        for (var i = 0; i < data.cartproduct.length; i++) {
          quantity += data.cartproduct[i].quantity;
          prodId.add(data.cartproduct[i].id);
        }
        data.finalDeliveryCharge(
            productIds: prodId.toString(),
            totalQuantity: quantity.toString(),
            totalPrice: data.totalprice);
      });

      setState(() {
        isLoading = false;
        isError = true;
      });
    });
    //  final data =  Provider.of<CartProvider>(context, listen: false);
    //       data.cartProductIdForCartScreen(context: context).then((value) {
    //         print(data.cartproduct.length.toString() + 'vaala thoti payalae');
    //       });
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<CartProvider>(context);
    final product = Provider.of<ProductProvider>(context);
    final cartproduct = data.cartproduct;
    void alertBox() async {
      return await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Clear Cart"),
          content: const Text("Do you want to clear all Cart Product"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                data.removeAllCartProd(context: context);
                product.productpagerefresh();

                Navigator.of(ctx).pop();
              },
              child: const Text("Clear"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      );
    }
    // final total = data.totalAmount;

    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: data.cartproduct.isEmpty
                ? Container()
                : Center(
                    child: InkWell(
                        onTap: () {
                          setState(() {});
                          alertBox();
                        },
                        child: ElevatedButton(
                          child: Text(
                            'Clear Cart',
                            style: TextStyle(
                                color: CustomColor.whitecolor,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                        // Text(
                        //   'Clear Favourite',
                        //   style: CustomThemeData().clearStyle(),
                        // ),
                        ),
                  ),
          )
        ],
      ),

      body: data.cartproduct.isEmpty
          ? const EmptyCartScreen()
          : isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(
                      animating: true,
                      color: CustomColor.orangecolor,
                      radius: 20),
                )
              : data.isError
                  ? const Center(
                      child: Text('Something went wrong'),
                    )
                  : const CartScreenDesign(),

      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.transparent,
      //   elevation: 0,
      //   child: Container(
      //     margin: const EdgeInsets.all(10),
      //     width: size.width,
      //     height: size.height * 0.05,
      //     child: ElevatedButton(
      //         onPressed: () {}, child: Text('Select Address at next')),
      //   ),
      // ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Container(
      //     width: size.width,
      //     height: size.height * 0.05,
      //     child: Text(data.shippingcharge.toString()),
      //   ),
      // ),
    );
  }
}
