import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_app/const/color_const.dart';

import 'package:food_app/const/theme.dart';
import 'package:food_app/provider/favourite_provider.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/screen/FavouriteScreen/favourite_empty_screen.dart';

import 'package:food_app/widget/favourite_product_wid/favourite_design.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key key}) : super(key: key);
  static const routeName = 'favourite-screen';

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    // Provider.of<ProductProvider>(context, listen: false)
    //     .filterProduct(startingPrice: 100, endingPrice: 1000);
    Provider.of<FavouriteProvider>(context, listen: false)
        .getFavouriteProductId(context: context)
        .then((value) {
      isloading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FavouriteProvider>(context);
    final fav = data.fav;
    // Size size = MediaQuery.of(context).size;
    // final data = Provider.of<FavouriteProvider>(context, listen: false);
    // GlobalServices globalServices = GlobalServices();
    void alertBox() async {
      return await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Clear Favourite"),
          content: const Text("Do you want to clear all Favourite Product"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                data.removeAllFavProd(context: context);
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

    print('Clear');
    print('Cancel');

    //final favproduct = data.fav;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favourite'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: InkWell(
                  onTap: () {
                    alertBox();
                  },
                  child: Text(
                    'Clear Favourite',
                    style: CustomThemeData().clearStyle(),
                  ),
                ),
              ),
            )
          ],
        ),
        body: isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : data.fav.isEmpty
                ? const EmptyFavouriteScreen()
                : Consumer<FavouriteProvider>(builder: (context, data, child) {
                    print(data.fav.length);
                    return Container(
                        color: CustomColor.whitecolor,
                        child: AnimationLimiter(
                          child: ListView.builder(
                              itemCount: fav.length,
                              itemBuilder: (ctx, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 300),
                                  child: ScaleAnimation(
                                    duration: const Duration(milliseconds: 300),
                                    child: FadeInAnimation(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: ChangeNotifierProvider.value(
                                          value: fav.toList()[index],
                                          child: FavouriteDesign(
                                            productId: fav[index].id,
                                          )),
                                    ),
                                  ),
                                );
                              }),
                        ));
                  }));
  }
}