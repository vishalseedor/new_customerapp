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

class ShowAllProductDesign extends StatefulWidget {
  const ShowAllProductDesign({Key key}) : super(key: key);

  @override
  State<ShowAllProductDesign> createState() => _ShowAllProductDesignState();
}

class _ShowAllProductDesignState extends State<ShowAllProductDesign> {
  List<int> add = [];
  bool cartadd = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    void favIconButtton() {
      var data = Provider.of<FavouriteProvider>(context, listen: false).fav;
      // print('fav product lemngth ${data.length}');
      final product =
          Provider.of<ProductProvider>(context, listen: false).product;

      if (data.isNotEmpty) {
        for (var i = 0; i < product.length; i++) {
          print(product.length.toString() + 'product length');
          print('product length is loading --->');
          for (var j = 0; j < data.length; j++) {
            print(data.length.toString() + 'data length');
            print('data length is loading --->');
            if (product[i].productId == data[j].id) {
              print(data[j].id +
                  '  Fav product is true  ' +
                  product[i].productId);

              product[i].isFavourite = true;
            } else {
              print('Fav product is false' + product[i].productId);
              print('button is loading ---->');

              // product[i].isFavourite = false;
            }
          }
        }
      } else if (data.isEmpty) {
        print('data call is not possible in api call');
        print('data empty in favourite');

        for (var i = 0; i < product.length; i++) {
          product[i].isFavourite = false;
        }
      }
    }

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
                      print('favourite product api loading');
                      if (product.isFavourite == false) {
                        await Provider.of<FavouriteProvider>(context,
                                listen: false)
                            .addFavouriteProductPostApi(
                                context: context, productId: product.productId)
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
                        print('fav loading is in complete');
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
                    style: Theme.of(context).textTheme.subtitle2,
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
                                  product.isCartButton();
                                }
                              });
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
