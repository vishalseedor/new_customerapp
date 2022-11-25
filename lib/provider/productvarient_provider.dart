import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/config.dart';
import '../models/product.dart';
import '../services/snackbar.dart';
import 'address/address_provider.dart';
import 'cart_provider.dart';
import 'favourite_provider.dart';
import 'package:http/http.dart' as http;

class ProductVarientProvider with ChangeNotifier {
  GlobalSnackBar snackBar = GlobalSnackBar();
  bool _data = true;
  bool get data {
    // boolData();
    return _data;
  }

  bool _homeScreenLoading = false;

  bool get homeScreenLoading {
    return _homeScreenLoading;
  }

  void boolDataFalse() async {
    _data = false;
  }

  void boolDataTrue() {
    _data = true;
  }

  // Future<void> boolData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('pages', true);
  //   _data = prefs.getBool('pages');
  //   notifyListeners();
  // }

  List<Product> _product = [];

  List<Product> get product {
    return [..._product];
  }

  bool _loadingSpinner = false;

  bool get loadingSpinner {
    return _loadingSpinner;
  }

  Future<void> valuePart({BuildContext context}) async {
    try {
      _homeScreenLoading = true;
      final data = Provider.of<ProductVarientProvider>(context, listen: false);
      print('hekllo hello hello');
      final prefs = await SharedPreferences.getInstance();
      print(data.data.toString() + ' confirmation');
      if (data.data == true) {
        print('count');
        Provider.of<ProductVarientProvider>(context, listen: false)
            .boolDataFalse();
        await Provider.of<AddressProvider>(context, listen: false)
            .getAddressData(context)
            .then((value) async {
          await Provider.of<FavouriteProvider>(context, listen: false)
              .getFavouriteProductId(context: context)
              .then((value) async {
            await Provider.of<CartProvider>(context, listen: false)
                .cartProductId(
              context: context,
            );
          });
        });
      } else if (data.data == false) {
        print('false false false');
        _homeScreenLoading = false;
        notifyListeners();
      }
      // setState(() {
      //   isLoadings = false;
      // });
    } catch (e) {
      _homeScreenLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProductData(
      BuildContext context, String productvarientid) async {
    print('product api start -- 1');
    try {
      _loadingSpinner = true;

      List<Product> _loadedProduct = [];
      print('product api start -- 2');
      var headers = {
        'Content-Type': 'application/json',
      };
      print('product api start -- 3');
      // var body = json.encode({
      //   "clientid": client_id,
      //   "type": "products",
      //   "domain": "[('product_variant_ids','=',[$productvarientid])]",
      //   "fields": "{'product_variant_id','product_variant_ids'}"
      // });

      // print(body + 'product varient is loading');

      var response = await http.get(
        Uri.parse(
            "http://eiuat.seedors.com:8001/seedor-api/all-products?clientid=bookseedorpremiumuat&type=products&fields={'active','id','categ_id','list_price','description','display_name','pricelist_id','product_variant_id','product_variant_ids','image_location','standard_price_tax_included','price_included'}&userid=11563&domain=[('product_variant_ids','=',[$productvarientid])]"),
        headers: headers,
      );
      print(
          "http://eiuat.seedors.com:8001/seedor-api/all-products?clientid=bookseedorpremiumuat&type=products&fields={'active','id','categ_id','list_price','description','display_name','pricelist_id','product_variant_id','product_variant_ids','image_location','standard_price_tax_included','price_included'}&userid=11563&domain=[('product_variant_ids','=',[$productvarientid])]");

      print(response.body + 'product response');
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        for (var i = 0; i < extractedData.length; i++) {
          print(extractedData[i]['display_name']);
          double price = extractedData[i]['standard_price_tax_included'];
          print('bool 1 is loading --->');

          final imageData = extractedData[i]['image_location'].toString();

          print('bool 2 is loading--->');
          print(extractedData[i]['product_variant_id']);

          _loadedProduct.add(Product(
              categories: extractedData[i]['categ_id'][0].toString(),
              colories: '40',
              description: extractedData[i]['description'].toString(),
              imageUrl: imageData,
              price: price.toInt(),
              productId: extractedData[i]['id'].toString(),
              quantity: 1,
              rating: 3,
              review: [],
              isFavourite: extractedData[i]['in_fav'],
              isSelect: false,
              isCart: extractedData[i]['in_cart'],
              subtitle: 'food',
              timer: 40,
              varient: extractedData[i]['product_variant_id'][0],
              title: extractedData[i]['display_name'].toString(),
              taxtext: extractedData[i]['price_included'].toString()));
        }
        _product = _loadedProduct;
        _loadingSpinner = false;
        print('loading completed -->>');
        notifyListeners();
      } else {
        snackBar.generalSnackbar(
            context: context, text: 'Something went wrong');
        _loadingSpinner = false;
        notifyListeners();
      }

      // _categories.map((data) {
      //   return Categories.fromMap(data);
      // }).toList();
      _loadingSpinner = false;

      notifyListeners();
    } on HttpException catch (e) {
      print('error in category prod -->>' + e.toString());
      _loadingSpinner = false;
      notifyListeners();
      snackBar.generalSnackbar(context: context, text: 'Something went wrong');
    }
  }

  List<Product> categoryProduct(String categoryName) {
    final category = product.where((element) =>
        element.categories.toLowerCase().contains(categoryName.toLowerCase()));
    return category.toList();
  }

  Product findById(String id) {
    return product.firstWhere((element) => element.productId == id);
  }
}
