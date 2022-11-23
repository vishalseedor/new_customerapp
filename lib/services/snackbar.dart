import 'package:flutter/material.dart';
import 'package:food_app/const/color_const.dart';
import 'package:food_app/const/theme.dart';
import 'package:food_app/provider/bottom_navigationbar_provider.dart';

import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/screen/bottom_app_screen.dart';

import 'package:provider/provider.dart';

import '../screen/cart_screen/cart_screen.dart';

class GlobalSnackBar {
  customSnackbar({
    BuildContext context,
  }) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final navigation =
        Provider.of<BottomNavigationBarProvider>(context, listen: false);
    final product = Provider.of<ProductProvider>(context, listen: false);

    final cartcount = cart.cartTotalProductdata;
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              height: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${product.cartProductTotal.length} ITEM'),
                  Row(
                    children: const [
                      Text('Product Add successfull'),
                      SizedBox(
                        width: 10,
                      ),
                      // const Text(
                      //   'plus taxes',
                      //   style: TextStyle(
                      //       fontSize: 12, color: CustomColor.whitecolor),
                      // )
                    ],
                  ),
                ],
              )),
          InkWell(
              onTap: () {
                navigation.currentIndex = 0;
                Navigator.of(context).pushNamed(BottomAppScreen.routeName);
                navigation.currentIndex = 2;
                Navigator.of(context).pop(navigation.currentIndex = 2);
                Navigator.of(context).pushNamed(MyCartScreen.routeName);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.of(context).pop();
              },
              child: Text('VIEW CART', style: CustomThemeData().drawerStyle()))
        ],
      ),
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: CustomColor.orangecolor,
      behavior: SnackBarBehavior.floating,
      // action: SnackBarAction(
      //   textColor: CustomColor.whitecolor,
      //   label: 'View cart',
      //   onPressed: () {},
      // ),
    );
  }

  generalSnackbar({BuildContext context, String text}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: SizedBox(
        height: 40,
        child: Center(
          child: Text(text),
        ),
      ),

      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: CustomColor.orangecolor,
      duration: const Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
      // action: SnackBarAction(
      //   textColor: CustomColor.whitecolor,
      //   label: 'View cart',
      //   onPressed: () {},
      // ),
    ));
  }

  successsnackbar({BuildContext context, String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: SizedBox(
        height: 40,
        child: Center(
          child: Text(text),
        ),
      ),

      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: CustomColor.greencolor,
      duration: const Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
      // action: SnackBarAction(
      //   textColor: CustomColor.whitecolor,
      //   label: 'View cart',
      //   onPressed: () {},
      // ),
    ));
  }
}
