import 'package:flutter/material.dart';
import 'package:food_app/const/color_const.dart';
import 'package:food_app/const/image_base64.dart';
import 'package:food_app/models/product.dart';
import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/provider/favourite_provider.dart';
import 'package:food_app/provider/productvarient_provider.dart';
import 'package:food_app/screen/product_detail_screen.dart';
import 'package:food_app/services/dialogbox.dart';
import 'package:food_app/services/snackbar.dart';
import 'package:provider/provider.dart';

import '../../provider/product_provider.dart';

class RelatatedProdWid extends StatefulWidget {
  const RelatatedProdWid({Key key}) : super(key: key);

  @override
  State<RelatatedProdWid> createState() => _RelatatedProdWidState();
}

class _RelatatedProdWidState extends State<RelatatedProdWid> {
  bool loading = false;
  void cartIconButtton() {
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

  void relatedProductFav() {
    var data = Provider.of<FavouriteProvider>(context, listen: false).fav;
    // print('fav product lemngth ${data.length}');
    final product =
        Provider.of<ProductVarientProvider>(context, listen: false).product;

    if (data.isNotEmpty) {
      // loading = true;
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

  void favIconButtton() {
    var data = Provider.of<FavouriteProvider>(context, listen: false).fav;
    // print('fav product lemngth ${data.length}');
    final product =
        Provider.of<ProductProvider>(context, listen: false).product;

    if (data.isNotEmpty) {
      // loading = true;
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final productCategory = Provider.of<Product>(context);
    final favbutton = Provider.of<FavouriteProvider>(context);
    final cart = Provider.of<CartProvider>(context);
    final cartproduct = cart.cartproduct;
    Size size = MediaQuery.of(context).size;
    GlobalServices _services = GlobalServices();
    GlobalSnackBar _snackbar = GlobalSnackBar();
    // final base64 = productCategory.imageUrl == ''
    //     ? customBase64
    //     : productCategory.imageUrl;
    // var image = base64Decode(base64);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailsScreen.routeName, arguments: {
          'productId': productCategory.productId,
          'productVarientId': productCategory.varient
        });
      },
      child: SizedBox(
        width: size.width * 0.48,
        // height: size.height * 0.02,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(5),
          color: CustomColor.whitecolor,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.13,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: productCategory.imageUrl == ""
                      ? Image.asset(seedorimage24)
                      : Image.network(
                          productCategory.imageUrl,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              Flexible(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      productCategory.title,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                    Text(
                      'Price : ₹' + productCategory.price.toString(),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(productCategory.taxtext ?? '',
                        style: TextStyle(
                            color: CustomColor.bluecolor, fontSize: 15))
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     SizedBox(
                    //         height: size.height * 0.04,
                    //         child: ElevatedButton(
                    //             child: Text(product.isCart == true
                    //                 ? 'In cart'
                    //                 : 'Add to cart'),
                    //             onPressed: () {
                    //               if (product.isCart == true) {
                    //                 _services.customDialog(
                    //                     context,
                    //                     product.title,
                    //                     'This product is already in cart');
                    //               } else {
                    //                 cart
                    //                     .cartProductPost(
                    //                         context: context,
                    //                         productId: product.productId,
                    //                         quantity: 1)
                    //                     .then((value) {
                    //                   cart
                    //                       .cartProductId(context: context)
                    //                       .then((value) {
                    //                     cartIconButtton();
                    //                     product.isCart = true;
                    //                   });
                    //                 });

                    //                 // cart.addToCart(
                    //                 //     id: product.productId,
                    //                 //     title: product.title,
                    //                 //     price: product.price.roundToDouble(),
                    //                 //     imageUrl: base64Decode(customBase64),
                    //                 //     quantity: product.quantity);
                    //                 ScaffoldMessenger.of(context).showSnackBar(
                    //                     _snackbar.customSnackbar(
                    //                         context: context));
                    //               }
                    //             })),
                    //     InkWell(
                    //         onTap: () async {
                    //           if (loading) {
                    //             print('loading');
                    //           } else {
                    //             if (productCategory.isFavourite == false) {
                    //               setState(() {
                    //                 loading = true;
                    //               });

                    //               await Provider.of<FavouriteProvider>(context,
                    //                       listen: false)
                    //                   .addFavouriteProductPostApi(
                    //                       context: context,
                    //                       productId: productCategory.productId)
                    //                   .then((value) {
                    //                 Provider.of<FavouriteProvider>(context,
                    //                         listen: false)
                    //                     .getFavouriteProductId(context: context)
                    //                     .then((value) {
                    //                   setState(() {
                    //                     loading = false;
                    //                   });
                    //                   favIconButtton();
                    //                   relatedProductFav();
                    //                 });
                    //               });

                    //               // favprodu.addToFavourite(
                    //               //     id: product.productId,
                    //               //     title: product.title,
                    //               //     price: product.price,
                    //               //     image: base64Decode(customBase64),
                    //               //     subtitle: product.subtitle);
                    //             } else if (productCategory.isFavourite ==
                    //                 true) {
                    //               setState(() {
                    //                 loading = true;
                    //               });
                    //               await Provider.of<FavouriteProvider>(context,
                    //                       listen: false)
                    //                   .deleteFavourite(
                    //                 prodId: productCategory.productId,
                    //                 context: context,
                    //               )
                    //                   .then((value) async {
                    //                 await Provider.of<FavouriteProvider>(
                    //                         context,
                    //                         listen: false)
                    //                     .getFavouriteProductId(
                    //                   context: context,
                    //                 )
                    //                     .then((value) {
                    //                   setState(() {
                    //                     loading = false;
                    //                   });
                    //                   print(value.toString() + 'helo helo');
                    //                   favIconButtton();
                    //                   productCategory.isFavourite = false;
                    //                 });
                    //               });
                    //             }
                    //             print('normal data');
                    //             // print(product.productId + 'product id');
                    //             // print(favprodu.fav[0].id + 'product id');

                    //           }
                    //         },
                    //         child: loading
                    //             ? CupertinoActivityIndicator(
                    //                 animating: true,
                    //                 color: CustomColor.orangecolor,
                    //                 radius: 15,
                    //               )
                    //             : Icon(
                    //                 productCategory.isFavourite
                    //                     ? Icons.favorite
                    //                     : Icons.favorite_outline,
                    //                 color: productCategory.isFavourite
                    //                     ? CustomColor.orangecolor
                    //                     : CustomColor.blackcolor,
                    //               ))
                    //   ],
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
