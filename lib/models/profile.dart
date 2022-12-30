import 'package:flutter/cupertino.dart';

class ProfileModel with ChangeNotifier {
  final String id;
  final String city;
  final String companyName;
  final String email;
  final String mobile;
  final String name;
  final String stateid;
  final String street;
  final String streetTwo;
  final String country;
  final String state;
  final String pincode;
  final String image;

  ProfileModel(
      {@required this.id,
      @required this.city,
      @required this.companyName,
      @required this.email,
      @required this.mobile,
      @required this.name,
      @required this.stateid,
      @required this.street,
      @required this.streetTwo,
      @required this.country,
      @required this.state,
      @required this.pincode,
      @required this.image
      });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    String stateId;
    String state;
    String country;
    if (json['primary_address'][0]['state_id'].toString() != 'false') {
      stateId = json['primary_address'][0]['state_id'][0].toString();
       state = json['primary_address'][0]['state_id'][1].toString();
    } else {
      stateId = 'Not yet Updated';
      state = 'State';
    }


    if (json['primary_address'][0]['country_id'].toString() != 'false') {
      
       country = json['primary_address'][0]['country_id'][1].toString();
    } else {
     
      country = 'Country';
    }

    return ProfileModel(
      city: json['primary_address'][0]['city'].toString(),
      companyName: json['primary_address'][0]['company_name'].toString(),
      email: json['primary_address'][0]['email'].toString(),
      id: json['primary_address'][0]['id'].toString(),
      mobile: json['primary_address'][0]['mobile'].toString(),
      name: json['primary_address'][0]['name'].toString(),
      stateid: stateId,
      streetTwo: json['primary_address'][0]['street2'].toString(),
      street: json['primary_address'][0]['street'].toString(),
      country: country,
      state: state,
      pincode:json['primary_address'][0]['zip'].toString(),
      image: json['primary_address'][0]['image_1024'].toString()
    );
  }
}
