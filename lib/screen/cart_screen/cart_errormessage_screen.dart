import 'package:flutter/material.dart';
import 'package:food_app/screen/cart_screen/cart_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/cart_provider.dart';

class CartErrorMessageScreen extends StatefulWidget {
  const CartErrorMessageScreen({Key key}) : super(key: key);

  @override
  State<CartErrorMessageScreen> createState() => _CartErrorMessageScreenState();
}

class _CartErrorMessageScreenState extends State<CartErrorMessageScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            height: size.height * 0.1,
            width: size.width * 0.1,
            color: Colors.black,
            child: Center(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
          onPressed: () {
            // final data = Provider.of<CartProvider>(context, listen: false);
            // // data.clearcartTotalProductdata();

            // Provider.of<CartProvider>(context, listen: false)
            //     .cartProductId(context: context);

            // data.testCartProductIds(context: context).then((value) {
            //   data.totalCartData().then((value) {
            //     int quantity = 0;
            //     List<String> prodId = [];
            //     for (var i = 0; i < data.cartproduct.length; i++) {
            //       quantity += data.cartproduct[i].quantity;
            //       prodId.add(data.cartproduct[i].id);
            //     }
            //     data.finalDeliveryCharge(
            //         productIds: prodId.toString(),
            //         totalQuantity: quantity.toString(),
            //         totalPrice: data.totalprice);
            //   });
            // });
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("Something Went Wrong")),
          // SizedBox(
          //   height: size.height * 0.04,
          //   width: size.width * 0.3,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(MyCartScreen.routeName);
          //     },
          //     child: Text('Refresh'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
