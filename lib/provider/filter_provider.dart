import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_app/const/config.dart';

import '../const/image_base64.dart';
import '../models/product.dart';
import '../services/snackbar.dart';
import 'package:http/http.dart' as http;

class FilterProvider with ChangeNotifier {
  List<Product> _filterProduct = [];
  List<Product> get filterProducts {
    return [..._filterProduct];
  }

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

  bool _loadingSpinner = false;

  bool get loadingSpinner {
    return _loadingSpinner;
  }

  bool _isSelect = false;

  bool get isSelect {
    return _isSelect;
  }

  Future<void> getProductData(
      {@required BuildContext context,
      @required String startprice,
      @required String endprice,
      @required List<String> listOfId,
      @required bool isSelect}) async {
    try {
      // print(
      //     "[('list_price','>',$startprice),('list_price','<',$endprice),('id','= ${listOfId.toList().toString()})]");
      _loadingSpinner = true;
      notifyListeners();
      List<Product> _loadedProduct = [];
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cookie':
            'session_id=d798a1308109711d1021e60acdb94a7a97b883f6; session_id=19498c36d54a58956a096f20b669fdb5ee623949'
      };

      var response = await http.get(
        Uri.parse(
            "http://eiuat.seedors.com:8001/seedor-api/all-products?clientid=bookseedorpremiumuat&type=products&fields={'active','id','categ_id','list_price','description','display_name','pricelist_id','product_variant_id','product_variant_ids','image_location','standard_price_tax_included','price_included'}&userid=11563&domain=[('list_price','>','$startprice'),('list_price','<','$endprice'),('categ_id','=',${listOfId.toList().toString()})]"),
        headers: headers,
      );
      print(
          "http://eiuat.seedors.com:8001/seedor-api/all-products?clientid=bookseedorpremiumuat&type=products&fields={'active','id','categ_id','list_price','description','display_name','pricelist_id','product_variant_id','product_variant_ids','image_location','standard_price_tax_included','price_included'}&userid=11563&domain=[('list_price','>','$startprice'),('list_price','<','$endprice'),('categ_id','=',${listOfId.toList().toString()})]");

      var jsonData = json.decode(response.body);
      print(jsonData);
      if (response.statusCode == 200) {
        if (jsonData.isEmpty) {
          _loadingSpinner = false;
          notifyListeners();
        } else {
          for (var i = 0; i < jsonData.length; i++) {
            print(jsonData[i]['display_name']);
            double price = jsonData[i]['standard_price_tax_included'];

            final imageData = jsonData[i]['image_location'].toString();

            _loadedProduct.add(Product(
              isSelect: false,
              categories: jsonData[i]['categ_id'][0].toString(),
              colories: '40',
              description: jsonData[i]['description'].toString(),
              imageUrl: imageData,
              isFavourite: jsonData[i]['in_fav'],
              isCart: jsonData[i]['in_cart'],
              price: price.toInt(),
              startprice: price.toString(),
              endprice: price.toString(),
              productId: jsonData[i]['id'].toString(),
              quantity: 1,
              rating: 3,
              review: [],
              subtitle: jsonData[i]['categ_id'][1],
              timer: 40,
              title: jsonData[i]['display_name'].toString(),
              taxtext: jsonData[i]['price_included'].toString(),
            ));
          }
          _filterProduct = _loadedProduct;
          _loadingSpinner = false;
          notifyListeners();
        }
      } else {
        _loadingSpinner = false;
        notifyListeners();
      }
    } on HttpException catch (e) {
      print('error in product prod -->>' + e.toString());
      print(loadingSpinner);
      _loadingSpinner = false;
      _isSelect = false;
      notifyListeners();
      snackBar.generalSnackbar(context: context, text: 'Something went wrong');
    }
  }
}
