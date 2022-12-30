import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:food_app/const/config.dart';
import 'package:food_app/models/favourite.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/provider/shareprefes_provider.dart';
import 'package:food_app/services/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../const/image_base64.dart';

class FavouriteProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading {
    return _isLoading;
  }

  GlobalSnackBar globalSnackBar = GlobalSnackBar();
  final Map<String, Favourite> _favourite = {};
  Map<String, Favourite> get favourite {
    return {..._favourite};
  }

  List<Favourite> _fav = [];

  List<Favourite> get fav {
    return [..._fav];
  }

  List<int> _prodId = [];
  List<int> get prodId {
    return [..._prodId];
  }

  List<int> _testId = [];

  List<int> get testId {
    return [..._testId];
  }

  Future<String> addFavouriteProductPostApi(
      {BuildContext context, String productId})async{
    String statesCodec = '0';
    try {
      final data = Provider.of<UserDetails>(context, listen: false);
      await data.getAllDetails();
      var headers = {
        'Content-Type': 'application/json',
      };
      print(dateTimeNow);
      print(productId);
      var body = json.encode({
        "userid": data.id,
        "clientid": client_id,
        "productid": productId,
        "status": favouriteStatus,
        "created_date": dateTimeNow,
      });
      print(body);
      var response = await http.post(
          Uri.parse('http://eiuat.seedors.com:8290/customer-app/addtocart'),
          headers: headers,
          body: body);
      print('http://eiuat.seedors.com:8290/customer-app/addtocart' + 'fav');

      statesCodec = response.statusCode.toString();
      var jsonData = json.decode(response.body);
      print(jsonData);
      statesCodec = jsonData['code'];
      if (response.statusCode == 202) {
        print(response.body);
      } else {
        print(response.reasonPhrase);
      }
      print(statesCodec.toString() + 'Status code 1');
      print(response.statusCode.toString() + 'Status code 1');
      return response.statusCode.toString();
    } catch (e) {
      print(e.toString());
      print(e.toString() + 'error in add fav post api');
    }
    return statesCodec;
  }

  Future<void> getAllProductFavApi(List<int> prodId) async {
    try {
      // Map<String, Favourite> loadData = {};
      _isLoading = true;
      print(_isLoading.toString() + '-->> fav loading');
      notifyListeners();

      List<Favourite> loadData = [];
      var headers = {
        'Content-Type': 'application/json',
      };
      var body = json.encode({
        "product_ids": prodId,
      });
      print(body + 'productsssss');
      var response = await http.get(
        Uri.parse(
            "http://eiuat.seedors.com:8001/seedor-api/all-products?clientid=bookseedorpremiumuat&type=products&fields={'active','id','categ_id','list_price','description','display_name','pricelist_id','product_variant_id','product_variant_ids','image_location'}&userid=11563&domain=[('categ_id','!=','Seedor Products'),('id','=',$prodId)]"),
        headers: headers,
      );

      var jsonData = await json.decode(response.body).asMap();
      print('value started ');
      print(body);
      print(
          "http://eiuat.seedors.com:8001/seedor-api/all-products?clientid=bookseedorpremiumuat&type=products&fields={'active','id','categ_id','list_price','description','display_name','pricelist_id','product_variant_id','product_variant_ids','image_location'}&userid=11563&domain=[('categ_id','!=','Seedor Products'),('id','=',$prodId)]");
      print(response.body);

      print('bot value' + jsonData.toString());
      if (response.statusCode == 200) {
        for (var i = 0; i < jsonData.length; i++) {
          final imageData = jsonData[i]['image_location'].toString();
          loadData.add(Favourite(
            id: jsonData[i]['id'].toString(),
            productTitle: jsonData[i]['display_name'].toString(),
            productPrice: jsonData[i]['list_price'].toString(),
            imageUrl: imageData,
            productCategory: jsonData[i]['categ_id'][1].toString(),
          ));
          // loadData.
          // ignore: missing_return
          // _favourite.putIfAbsent('', () {
          //   Favourite(
          // id: jsonData[i]['create_uid'][0].toString(),
          // productTitle: jsonData[i]['display_name'].toString(),
          // productPrice: jsonData[i]['cart_qty'],
          // imageUrl: jsonData[i]['image_1024'],
          // productCategory: jsonData[i]['categ_id'][1]);
          //   notifyListeners();
          //   print('fav product ' + _favourite.toString());
          // });
          // loadData.putIfAbsent('32', () {
          //   print('welcome');

          //   // Favourite(
          //   //     id: jsonData[i]['create_uid'][0].toString(),
          //   //     productTitle: jsonData[i]['display_name'].toString(),
          //   //     productPrice: jsonData[i]['cart_qty'],
          //   //     imageUrl: jsonData[i]['image_1024'],
          //   //     productCategory: jsonData[i]['categ_id'][1]);
          // });

          print('simple' + loadData.toString());
        }
        _fav = loadData;
        print(_fav.length.toString() + 'fav data length');
        _isLoading = false;
        print('completed fav loading -->>');
        notifyListeners();
        print('kkkkkkk' + loadData.toString());
      } else {
        print(response.reasonPhrase);
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print('error');
      print('error in favourite -->>' + e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future getFavouriteProductId(
      {BuildContext context, String id, productId}) async {
    try {
      List<int> id = [];
      print('runing runing runing');
      final data = Provider.of<UserDetails>(context, listen: false);

      await data.getAllDetails();

      var response = await http.get(
        Uri.parse(
            'http://eiuat.seedors.com:8290/customer-app/mycart/${data.id}?clientid=$client_id&status=favourite'),
      );
      print(
          'http://eiuat.seedors.com:8290/customer-app/mycart/${data.id}?clientid=$client_id&status=favourite');
      print(response.toString() + 'gjgjgjhgjg');

      if (response.statusCode == 200) {
        // print('No product');
        var jsonData = json.decode(response.body);
        if (jsonData['entries'].toString() != '{}') {
          // var jsonData = json.decode(response.body);

          // print(response.body);
          print('favourite product 200');
          for (var i = 0; i < jsonData['entries']['entry'].length; i++) {
            // print('welcome fav' + jsonData['entries']['entry'][i].toString());
            // print(jsonData['entries']['entry'][i]['productid']);
            id.add(int.parse(jsonData['entries']['entry'][i]['productid']));
            // print('product id + ${id[i]}');

            _prodId = id;

            print('product id final' + _prodId.toString());
          }

          await getAllProductFavApi(_prodId);
        } else {
          _prodId = [];
          await getAllProductFavApi(_prodId);
        }
      } else {}
    } catch (e) {
      print(e.toString());
      print(e.toString() + 'error in get favourite pro');
      print('Something went wrong jjdhjdgj');
      print('Something went wrong nnnnmmmmkkkkk');
    }
  }

  // Future<void> favProdId({@required BuildContext context}) async {
  //   try {
  //     List<int> id = [];
  //     print('runing runing runiing');
  //     final data = Provider.of<UserDetails>(context, listen: false);

  //     data.getAllDetails();

  //     var response = await http.get(
  //       Uri.parse(
  //           'http://eiuat.seedors.com:8290/customer-app/mycart/${data.id}?clientid=$client_id&status=favourite'),
  //     );

  //     if (response.statusCode == 200) {
  //       print('No product');
  //       var jsonData = json.decode(response.body);
  //       if (jsonData['entries'].toString() != '{}') {
  //         // var jsonData = json.decode(response.body);

  //         print(response.body);
  //         print('favourite product 200');
  //         for (var i = 0; i < jsonData['entries']['entry'].length; i++) {
  //           print('welcome fav' + jsonData['entries']['entry'][i].toString());
  //           print(jsonData['entries']['entry'][i]['productid']);
  //           id.add(int.parse(jsonData['entries']['entry'][i]['productid']));
  //           print('product id + ${id[i]}');

  //           _testId = id;

  //           print('product id final' + _prodId.toString());
  //         }
  //         // await getAllProductFavApi(_prodId);
  //       } else {
  //         _testId = [];
  //         // await getAllProductFavApi(_prodId);
  //       }
  //     } else {}
  //   } catch (e) {
  //     print(e.toString());
  //     print('Something went wrong jjdhjdgj');
  //   }
  // }

  Future<int> deleteFavourite(
      {@required String prodId, @required BuildContext context}) async {
    try {
      final user = Provider.of<UserDetails>(context, listen: false);
      
      await user.getAllDetails();
      var headers = {
        'Content-Type': 'application/json',
      };
      var body = json.encode({
        "productid": prodId,
        "userid": user.id,
        "clientid": client_id,
        "status": favouriteStatus,
      });
      print(body);
      var response = await http.delete(
        Uri.parse('http://eiuat.seedors.com:8290/customer-app/remove-cart'),
        headers: headers,
        body: body,
      );
      print('remove api loading--->');
      print(response.body.toString() + 'sgysgygygygg');
      if (response.statusCode == 202) {
        _fav.removeWhere((element) => element.id == prodId);
      

        notifyListeners();
        globalSnackBar.generalSnackbar(
            context: context, text: 'Removed From Favourites');
      } else {}
      return response.statusCode;
    } catch (e) {
      print(e.toString());
      print(prodId);
    }
  }

  Future<void> removeAllFavProd({BuildContext context}) async {
    try {
      var data = Provider.of<UserDetails>(context, listen: false);
      var product=Provider.of<ProductProvider>(context,listen: false);
      await data.getAllDetails();
      var header = {
        'Content-Type': 'application/json',
      };
      var body = json.encode({
        "userid": data.id.toString(),
        "clientid": client_id,
        "status": "favourite"
      });
      print(body);
      var response = await http.delete(
          Uri.parse('http://eiuat.seedors.com:8290/customer-app/clear-cart'),
          body: body,
          headers: header);
      print(response.body + 'clear-cart');
      if (response.statusCode == 202) {
        globalSnackBar.generalSnackbar(
            context: context, text: 'Your favourite is clear');
        _fav.clear();
        product.clearfavrefresh();
        

        notifyListeners();
      } else {
        globalSnackBar.generalSnackbar(
            context: context, text: 'Something went wrong');
      }
    } catch (e) {
      print(e.toString());
      // globalSnackBar.generalSnackbar(
      //     context: context, text: 'Something went wrong');

    }
  }

  void addToFavourite({
    @required String id,
    @required String title,
    @required int price,
    @required Uint8List image,
    @required String subtitle,
  }) {
    if (_favourite.containsKey(id)) {
      _favourite.remove(id);
    } else {
      _favourite.putIfAbsent(
          id,
          () => Favourite(
              id: DateTime.now().microsecond.toString(),
              productTitle: title,
              productPrice: price.toString(),
              imageUrl: null,
              productCategory: subtitle));
    }
    notifyListeners();
  }

  void removeItem(
      {@required String productId, @required BuildContext context}) async {
    _fav.removeWhere((element) => element.id == productId);
    await deleteFavourite(prodId: productId, context: context);
    notifyListeners();
  }
}
