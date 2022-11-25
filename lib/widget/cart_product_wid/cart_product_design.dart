import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/const/color_const.dart';
import 'package:food_app/models/cart.dart';

import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

class CartProductDesign extends StatefulWidget {
  final String productId;
  final int index;
  bool screenRefresh;
  CartProductDesign(
      {Key key,
      @required this.productId,
      @required this.index,
      @required this.screenRefresh})
      : super(key: key);

  @override
  State<CartProductDesign> createState() => _CartProductDesignState();
}

class _CartProductDesignState extends State<CartProductDesign> {
  List<int> productId = [];
  @override
  void initState() {
    super.initState();
    final cartId = Provider.of<CartProvider>(context, listen: false);
    Provider.of<CartProvider>(context, listen: false)
        .cartProductId(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final cartProduct = Provider.of<CartTotalProductModal>(context);
    final product = Provider.of<ProductProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    // final address = Provider.of(context);
    Size size = MediaQuery.of(context).size;

    var subtotal = 0.0;
    subtotal = double.parse(cartProduct.price) * cartProduct.quantity;

    return cart.isLoading
        ? const Center(
            child: CupertinoActivityIndicator(
                animating: true, color: CustomColor.orangecolor, radius: 20),
          )
        : Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: CustomColor.grey100)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cart.cartTotalProductdata[widget.index].title),
                            Text(
                              "Price ₹ " +
                                  cart.cartTotalProductdata[widget.index].price,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),

                            // Text('Price excluded',
                            //     style: TextStyle(fontSize: 12))
                            // Text(cart.cartTotalProductdata[widget.index]
                            //         .priceincluds ??
                            //     '')
                          ]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: size.height * 0.04,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: CustomColor.orangecolor)),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // if (cartProduct.quantity == 1) {
                                    //   cart.removeCart(widget.productId);
                                    // } else {
                                    if (cartProduct.quantity == 1) {
                                      cart
                                          .cartProductPost(
                                        context: context,
                                        productId: widget.productId,
                                        quantity: cartProduct.quantity - 1,
                                      )
                                          .then((value) {
                                        cart
                                            .deleteCart(
                                          index: widget.index,
                                          prodId: widget.productId,
                                          context: context,
                                        )
                                            .then((value) {
                                          product.countproductremove(
                                              id: widget.productId);
                                        });
                                        for (var i = 0;
                                            i < product.product.length;
                                            i++) {
                                          print(product.product[i].productId);
                                          if (product.product[i].productId ==
                                              widget.productId) {
                                            print(product.product[i].productId
                                                    .toString() +
                                                'in if class');
                                            product.product[i].isCart = false;
                                          }
                                        }
                                      });
                                    }
                                    if (cartProduct.quantity > 1) {
                                      cart
                                          .cartProductPost(
                                        context: context,
                                        productId: widget.productId,
                                        quantity: cartProduct.quantity - 1,
                                      )
                                          .then((value) {
                                        setState(() {
                                          cartProduct.quantity--;
                                          cart
                                              .cartTotalProductdata[
                                                  widget.index]
                                              .quantity--;
                                        });
                                      });
                                    }

                                    // }
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.remove),
                                  ),
                                ),
                                Text(
                                  cartProduct.quantity.toString(),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cart
                                        .cartProductPost(
                                      context: context,
                                      productId: widget.productId,
                                      quantity: cartProduct.quantity + 1,
                                    )
                                        .then((value) {
                                      setState(() {
                                        cartProduct.quantity++;
                                      });
                                    });
                                    // cart.addToCart(
                                    //     id: widget.productId,
                                    //     // title: cartProduct.title,
                                    //     // price: double.parse(cartProduct.price),
                                    //     // index: widget.index,
                                    //     // imageUrl: cartProduct.imageUrl,
                                    //     quantity: cartProduct.quantity + 1);
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹ ' +
                                (double.parse(cart
                                            .cartTotalProductdata[widget.index]
                                            .price) *
                                        cartProduct.quantity)
                                    .toString(),
                            style: Theme.of(context).textTheme.subtitle2,
                          )
                        ],
                      )
                    ],
                  ),
                  ...List.generate(
                      cart.cartTotalProductdata[widget.index].cartCharge.length,
                      (index) {
                    if (cart.cartTotalProductdata[widget.index]
                            .cartCharge[index].id ==
                        '') {
                      return Container();
                    } else {
                      return Container(
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              child: Card(
                                color: CustomColor.greencolor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.done,
                                  size: 12,
                                  color: CustomColor.whitecolor,
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 16,
                                child: Text(
                                  cart.cartTotalProductdata[widget.index]
                                      .cartCharge[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle2,
                                )),
                            Expanded(
                                flex: 3,
                                child: Text(
                                  '₹' +
                                      (double.parse(cart
                                                  .cartTotalProductdata[
                                                      widget.index]
                                                  .cartCharge[index]
                                                  .price) *
                                              cartProduct.quantity)
                                          .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle2,
                                )),
                          ],
                        ),
                      );
                    }
                  })
                ],
              ),
            ),
          );
  }
}
