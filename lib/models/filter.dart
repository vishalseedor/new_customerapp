import 'package:flutter/material.dart';

class getProductData {
  String startprice;
  String endprice;
  final List<int> listOfId;
   bool isSelect = false;
  // bool isFavourite = false;
  // bool isCart = false;

  getProductData({
    @required this.startprice,
    @required this.endprice,
     this.listOfId,
    @required this.isSelect,
    //  this.isCart = false,
    //  this.isFavourite = false,
  });
}
