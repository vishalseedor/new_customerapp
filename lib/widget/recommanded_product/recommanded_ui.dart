import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/const/color_const.dart';
import 'package:food_app/const/image_base64.dart';
import 'package:food_app/models/product.dart';
import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/provider/favourite_provider.dart';
import 'package:food_app/screen/product_detail_screen.dart';
import 'package:food_app/services/dialogbox.dart';
import 'package:food_app/services/snackbar.dart';
import 'package:provider/provider.dart';

import '../../provider/product_provider.dart';

class RecommandedDesign extends StatefulWidget {
  const RecommandedDesign({Key key}) : super(key: key);

  @override
  State<RecommandedDesign> createState() => _RecommandedDesignState();
}

class _RecommandedDesignState extends State<RecommandedDesign> {
  void initState() {
    super.initState();
    print('inistate value');
    // favIconButtton();
    // Provider.of<CartProvider>(context, listen: false)
    //     .cartIconButtton(context: context);
  }

  bool loading = false;

  void favIconButtton() {
    var data = Provider.of<FavouriteProvider>(context, listen: false).fav;
    // print('fav product lemngth ${data.length}');
    final product =
        Provider.of<ProductProvider>(context, listen: false).product;

    if (data.isNotEmpty) {
      for (var i = 0; i < product.length; i++) {
        print(product.length.toString() + 'product length');
        for (var j = 0; j < data.length; j++) {
          print(data.length.toString() + 'data length');
          if (product[i].productId == data[j].id) {
            print(
                data[j].id + '  Fav product is true  ' + product[i].productId);
            product[i].isFavourite = true;
          } else {
            print('Fav product is false' + product[i].productId);

            // product[i].isFavourite = false;
          }
        }
      }
    } else if (data.isEmpty) {
      print('data empty in favourite');
      for (var i = 0; i < product.length; i++) {
        product[i].isFavourite = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final product = Provider.of<Product>(context);
    final productcount = Provider.of<ProductProvider>(context);
    final favourite = Provider.of<FavouriteProvider>(context);
    final cart = Provider.of<CartProvider>(context);
    final cartproduct = cart.cartproduct;
    GlobalSnackBar _snackbar = GlobalSnackBar();
    GlobalServices _services = GlobalServices();
    // final base64 = product.imageUrl == '' ? customBase64 : product.imageUrl;
    // var image = base64Decode(base64);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
            arguments: {
              'productId': product.productId,
              'productVarientId': product.varient
            });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: size.height * 0.27,
              width: size.width * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CustomColor.whitecolor,
              ),
              child: Card(
                elevation: 3,
                color: CustomColor.whitecolor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.01),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: CustomColor.grey400,
                        backgroundImage: product.imageUrl == ''
                            ? AssetImage(seedorimage24)
                            : NetworkImage(product.imageUrl),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          product.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        AutoSizeText(
                          product.subtitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        AutoSizeText('₹' + product.price.toString()),
                        Text(
                          product.taxtext ?? '',
                          style: TextStyle(
                              color: CustomColor.bluecolor, fontSize: 15),
                          // style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                child: Text(product.isCart == true
                                    ? 'In cart'
                                    : 'Add to cart'),
                                onPressed: () {
                                  if (product.isCart == true) {
                                    _services.customDialog(
                                        context,
                                        product.title,
                                        'This product is already in cart');
                                  } else {
                                    cart
                                        .cartProductPost(
                                            context: context,
                                            productId: product.productId,
                                            quantity: 1)
                                        .then((value) {
                                      if (value == '200') {
                                        productcount.countproductsadd(
                                            id: product.productId);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                                _snackbar.customSnackbar(
                                                    context: context));
                                        print(productcount.cartProductTotal
                                                .toString() +
                                            '--->> cart total count');
                                        product.isCartButton();
                                      }
                                    });

                                    // cart
                                    //     .cartProductPost(
                                    //         context: context,
                                    //         productId: product.productId,
                                    //         quantity: 1)
                                    //     .then((value) {
                                    //   cart
                                    //       .cartProductId(context: context)
                                    //       .then((value) {
                                    //     cart.cartIconButtton(context: context);
                                    //     product.isCart = true;
                                    //   });
                                    // });

                                    // cart.addToCart(
                                    //     id: product.productId,
                                    //     title: product.title,
                                    //     price: product.price.roundToDouble(),
                                    //     imageUrl: base64Decode(customBase64),
                                    //     quantity: product.quantity);

                                  }
                                }),
                            IconButton(
                                onPressed: () async {
                                  if (product.isFavourite == false) {
                                    await Provider.of<FavouriteProvider>(
                                            context,
                                            listen: false)
                                        .addFavouriteProductPostApi(
                                            context: context,
                                            productId: product.productId)
                                        .then((value) {
                                      if (value == '200') {
                                        print('its working fine da');
                                        product.isFavouriteButton();
                                      }
                                    });

                                    // setState(() {
                                    //   loading = true;
                                    // });

                                    // await Provider.of<FavouriteProvider>(context,
                                    //         listen: false)
                                    //     .addFavouriteProductPostApi(
                                    //         context: context,
                                    //         productId: product.productId)
                                    //     .then((value) {
                                    //   Provider.of<FavouriteProvider>(context,
                                    //           listen: false)
                                    //       .getFavouriteProductId(context: context)
                                    //       .then((value) {
                                    //     setState(() {
                                    //       loading = false;
                                    //     });
                                    //     // favIconButtton();
                                    //   });
                                    // });

                                    // // favprodu.addToFavourite(
                                    // //     id: product.productId,
                                    // //     title: product.title,
                                    // //     price: product.price,
                                    // //     image: base64Decode(customBase64),
                                    // //     subtitle: product.subtitle);
                                  } else if (product.isFavourite == true) {
                                    await Provider.of<FavouriteProvider>(
                                            context,
                                            listen: false)
                                        .deleteFavourite(
                                      prodId: product.productId,
                                      context: context,
                                    )
                                        .then((value) {
                                      if (value == 202) {
                                        product.isFavouriteButton();
                                      }
                                    });
                                  }

                                  // print(favprodu.fav[0].id + 'product id');

                                  // if (product.isFavourite == false) {
                                  //   setState(() {
                                  //     loading = true;
                                  //   });

                                  //   await Provider.of<FavouriteProvider>(
                                  //           context,
                                  //           listen: false)
                                  //       .addFavouriteProductPostApi(
                                  //           context: context,
                                  //           productId: product.productId)
                                  //       .then((value) {
                                  //     Provider.of<FavouriteProvider>(context,
                                  //             listen: false)
                                  //         .getFavouriteProductId(
                                  //             context: context)
                                  //         .then((value) {
                                  //       setState(() {
                                  //         loading = false;
                                  //       });
                                  //       favIconButtton();
                                  //     });
                                  //   });

                                  //   // favprodu.addToFavourite(
                                  //   //     id: product.productId,
                                  //   //     title: product.title,
                                  //   //     price: product.price,
                                  //   //     image: base64Decode(customBase64),
                                  //   //     subtitle: product.subtitle);
                                  // } else if (product.isFavourite == true) {
                                  //   setState(() {
                                  //     loading = true;
                                  //   });
                                  //   await Provider.of<FavouriteProvider>(
                                  //           context,
                                  //           listen: false)
                                  //       .deleteFavourite(
                                  //     prodId: product.productId,
                                  //     context: context,
                                  //   )
                                  //       .then((value) async {
                                  //     await Provider.of<FavouriteProvider>(
                                  //             context,
                                  //             listen: false)
                                  //         .getFavouriteProductId(
                                  //       context: context,
                                  //     )
                                  //         .then((value) {
                                  //       setState(() {
                                  //         loading = false;
                                  //       });
                                  //       print(value.toString() + 'helo helo');
                                  //       favIconButtton();
                                  //       product.isFavourite = false;
                                  //     });
                                  //   });
                                  // }
                                  // print('normal data');
                                  // print(product.productId + 'product id');
                                  // print(favprodu.fav[0].id + 'product id');
                                },
                                icon: loading
                                    ? const CupertinoActivityIndicator(
                                        color: CustomColor.orangecolor,
                                        radius: 14,
                                      )
                                    : Icon(
                                        product.isFavourite == true
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: product.isFavourite
                                            ? CustomColor.orangecolor
                                            : CustomColor.blackcolor,
                                        size: size.width * 0.06,
                                      )),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(13),
            //   child: AutoSizeText(
            //     '  ${product.colories} 🔥Calories',
            //     style: Theme.of(context).textTheme.caption,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
