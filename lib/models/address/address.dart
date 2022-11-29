import 'package:flutter/cupertino.dart';

class Addresss with ChangeNotifier {
  final String id;
  final String name;
  final String phoneNumber;
  final String pincode;
  final String houseNumber;
  final String area;
  final String landmark;
  final String town;
  final String country;
  final String countryId;
  final String state;
  final String addresstype;
  final String stateId;
  double lat;
  double lng;

  Addresss({
    this.id,
    this.stateId,
    this.name,
    this.phoneNumber,
    this.pincode,
    this.houseNumber,
    this.area,
    this.landmark,
    this.town,
    this.country,
    this.countryId,
    this.state,
    this.addresstype,
    this.lat,
    this.lng,
  });
}
