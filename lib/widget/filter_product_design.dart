import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/const/image_base64.dart';
import 'package:provider/provider.dart';

import '../const/color_const.dart';
import '../models/product.dart';
import '../provider/cart_provider.dart';
import '../provider/favourite_provider.dart';
import '../provider/product_provider.dart';
import '../screen/product_detail_screen.dart';
import '../services/dialogbox.dart';
import '../services/snackbar.dart';

class FilterProductDesign extends StatefulWidget {
  const FilterProductDesign({Key key}) : super(key: key);

  @override
  State<FilterProductDesign> createState() => _FilterProductDesignState();
}

class _FilterProductDesignState extends State<FilterProductDesign> {
  bool loading = false;
  @override
  void initState() {
    super.initState();
    // favIconButtton();
  }

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
    final favprod = Provider.of<FavouriteProvider>(context);
    final productcount = Provider.of<ProductProvider>(context);
    GlobalServices _services = GlobalServices();
    final cart = Provider.of<CartProvider>(context);
    final cartProduct = cart.cartproduct;

    final fav = favprod.favourite;

    GlobalSnackBar _snackbar = GlobalSnackBar();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
            arguments: {
              'productId': product.productId,
              'productVarientId': product.varient
            });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CustomColor.grey100),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: size.height * 0.15,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: product.imageUrl == ''
                      ? AssetImage(seedorimage24)
                      : NetworkImage(product.imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // print(favprodu.fav[0].id + 'product id');
                      print('hellooooooo ---->>>>');
                      if (loading) {
                        print('loading');
                      } else {
                        if (product.isFavourite == false) {
                          await Provider.of<FavouriteProvider>(context,
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
                          await Provider.of<FavouriteProvider>(context,
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

                        // print(product.productId + 'product id');
                        // print(favprodu.fav[0].id + 'product id');

                        // print(product.productId + 'product id');
                        // print(favprodu.fav[0].id + 'product id');

                      }
                    },
                    child: CircleAvatar(
                      // radius: 20,
                      backgroundColor: product.isFavourite
                          ? CustomColor.dryOrange
                          : CustomColor.whitecolor,
                      child: loading
                          ? const CupertinoActivityIndicator(
                              color: CustomColor.orangecolor,
                              radius: 15,
                              animating: true,
                            )
                          : Icon(
                              product.isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: product.isFavourite
                                  ? CustomColor.orangecolor
                                  : CustomColor.blackcolor,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  AutoSizeText(
                    '₹ ' + product.price.toString(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    product.taxtext ?? '',
                    style: TextStyle(color: CustomColor.orangecolor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: size.height * 0.04,
                        child: ElevatedButton(
                          child:
                              Text(product.isCart ? 'In cart' : 'Add to Cart'),
                          onPressed: () {
                            print('hellooooooo ---->>>>');
                            if (product.isCart == true) {
                              _services.customDialog(context, product.title,
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      _snackbar.customSnackbar(
                                          context: context));
                                  print('cart product add aguda');
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
                              //     cartIconButtton();
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
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
