

import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_app/const/color_const.dart';
import 'package:food_app/const/theme.dart';
import 'package:food_app/models/address/address.dart';
import 'package:food_app/models/dropdown.dart';
import 'package:food_app/provider/address/address_provider.dart';
import 'package:food_app/provider/auth_provider.dart';
import 'package:food_app/screen/google_maps/constants.dart';
import 'package:food_app/services/dialogbox.dart';
import 'package:food_app/services/location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';



class AddAddressScreen extends StatefulWidget {
  static const routeName = 'Add-Address';
  final String alertId;
  const AddAddressScreen({Key key, this.alertId}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
   final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _housenumberController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _stateIdController = TextEditingController();
  final TextEditingController _countryIdController = TextEditingController();
  final TextEditingController _addresstypeController = TextEditingController();
   String countryId = "";
   String stateId   = "";

  String selectedValue = "private";
  String stateIdDropdown;
  String countryIdDropdown;

  var isInit = true;
  bool isvisible = false;

   

  Position position;
  List<Placemark> placemark;
  String addresId;



  
 

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phonenumber.dispose();
    _pincodeController.dispose();
    _housenumberController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _townController.dispose();
    _countryIdController.dispose();
    _stateIdController.dispose();
    _addresstypeController.dispose();
  }

  var editAddress = Addresss(
      id: '',
      name: '',
      phoneNumber: '',
      pincode: '',
      houseNumber: '',
      area: '',
      // landmark: '',
      town: '',
      countryId: '',
      country: '',
      stateId: '',
      state: '',
      addresstype: '');
  var iniValue = {
    'name': '',
    'phonenumber': '',
    'pincode': '',
    'housenumber': '',
    'area': '',
    'landmark': '',
    'town': '',
    'country': '',
    'state': '',
    'addresstype': '',
  };

  final GlobalServices _services = GlobalServices();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {

    });
    final data = Provider.of<AddressProvider>(context, listen: false);
    Provider.of<CurrentLocation>(context, listen: false).determinePosition();
    Provider.of<AddressProvider>(context, listen: false)
        .CountryDropDownField(listAdds: data.countryDropDown, context: context)
        .then((value) {
        
        });
    // Provider.of<AddressProvider>(context,listen: false)
    //     .stateDropDownField(
    //       apiName: 'state_id',
    //       context: context,
    //       listAdd: data.stateDropDown,
    //       countryname: 'India'
        
    //     ).then((value){
    //       setState(() {
            
    //       });
    //     });
       
  }

  @override
  void didChangeDependencies() {
    // final addressId = ModalRoute.of(context)!.settings.arguments as String;
    // print('one' + addressId);
    final data = Provider.of<AddressProvider>(context, listen: false);
    if (isInit) {
      addresId = ModalRoute.of(context).settings.arguments as String;
      print(addresId.toString() + 'sushalt');
      if (addresId != null) {
        editAddress = Provider.of<AddressProvider>(context, listen: false)
            .findById(addresId);
            // editAddress.countryId;
           for(var i=0;i<data.countryDropDown.length;i++){
           if(editAddress.countryId==data.countryDropDown[i].id){
             countryId = data.countryDropDown[i].id;
            _countryIdController.text=data.countryDropDown[i].name;
            print(_countryIdController.text=data.countryDropDown[i].name.toString()+'country id vaaaaaaaaa');
            }
            // editAddress.stateId;
            for(var i=0;i<data.stateDropDown.length;i++){
              if(editAddress.stateId==data.stateDropDown[i].id){
                stateId=data.stateDropDown[i].id;
                _stateIdController.text=data.stateDropDown[i].title;
                print(_stateIdController.text=data.stateDropDown[i].title.toString()+'state id vaaaaaaaaa');
              }
            }
           
          }

            
        if (editAddress.state == null) {
        } else {
          print('<<<---->>>');
          print(editAddress.stateId);

          stateIdDropdown = editAddress.stateId;
        }
        print(editAddress.state +
            'jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
        if (editAddress.country == null) {
        } else {
          print(editAddress.countryId);
          countryIdDropdown = editAddress.countryId;
        }
        

        // if (stateIdDropdown != null) {
        //   editAddress = Provider.of<AddressProvider>(context, listen: false)
        //       .findById(stateIdDropdown);
        // }

        iniValue = {
          'name': '',
          'phonenumber': '',
          'pincode': '',
          'housenumber': '',
          'area': '',
          'landmark': '',
          'town': '',
          'state': '',
          'country_id':'',
          'state_id':'',
          'addresstype': '',
        };
        _nameController.text = editAddress.name;
        _phonenumber.text = editAddress.phoneNumber;
        _pincodeController.text = editAddress.pincode;
        _housenumberController.text = editAddress.houseNumber ?? '';
        _areaController.text = editAddress.area;
        // _landmarkController.text = editAddress.landmark;
        _townController.text = editAddress.town;
        _countryIdController.text = countryId;
        _stateIdController.text = stateId;
        stateIdDropdown = stateId;
        countryIdDropdown = countryId;
        _addresstypeController.text = selectedValue;
      }
    }
    isInit = false;

    super.didChangeDependencies();
  }

  void submit(){
   
    print(addresId.toString() + 'addressId from page');
    print(editAddress.id.toString() + 'addressid from edit');
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    if(countryId.isEmpty){
      // ignore: void_checks
      return _services.customDialog(context,'Country','Please enter your country');
      
    }
    else if(stateId.isEmpty){
      // ignore: void_checks
      return _services.customDialog(context,'State','Please enter your state');
    }
    else{

       _formKey.currentState.save();

    }
   
    if (addresId == editAddress.id) {
      print('edit address add');

      Provider.of<AddressProvider>(context, listen: false)
          .updateAddressData(editAddress, context)
          .then((value) {
        Provider.of<AddressProvider>(context, listen: false)
            .getAddressData(context)
            .then((value) {
          Navigator.of(context).pop();
          // Provider.of<AddressProvider>(context, listen: false)
          //     .stateDropDownField(
          //   countryId: '104',
          // );
        });
      });
    }
     else if (addresId == null) {
      print('new address add');
      Provider.of<AddressProvider>(context, listen: false)
          .addAddressData(editAddress, context)
          .then((value) {
        Provider.of<AddressProvider>(context, listen: false)
            .getAddressData(context)
            .then((value) {
          Navigator.of(context).pop();
        });
        //  Provider.of<AddressProvider>(context, listen: false)
        //     .stateDropDownField(countryId:'104');
      });
    }

    widget.alertId == 'id' ? Navigator.of(context).pop() : null;
  }

  Future<void> getCurrentLocation() async {
      final data = Provider.of<AddressProvider>(context, listen: false);
      Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;

    placemark =
        (await placemarkFromCoordinates(position.latitude, position.longitude));
    Placemark pMark = placemark[0];
    print(pMark);

    _pincodeController.text = pMark.postalCode;
    if (pMark.subLocality == null || pMark.subLocality == '') {
      _areaController.text = pMark.name;
    } else {
      _areaController.text = pMark.subLocality;
    }
     
    // if (pMark.administrativeArea == null || pMark.administrativeArea == '') {
    //   _stateIdController.text = pMark.administrativeArea;
    //   print(_stateIdController.text+'area vaaaaaaaaaaaa');
    // } else {
    //   print(_stateIdController.text+'area vaaaaaaaaaaaa');
    //   _stateIdController.text = pMark.administrativeArea;
    // }
    // if (pMark.country == null || pMark.country == '') {
    //   _countryController.text = pMark.country;
    // } else {
    //   _countryController.text = pMark.country;
    // }
    _countryIdController.text=pMark.country;
    Provider.of<AddressProvider>(context,listen: false).
       stateDropDownField(
        apiName: 'state_id',
        context: context,
        listAdd: data.stateDropDown,
        countryId: pMark.country,
        );
        print(data.stateDropDown);
        print(pMark.country);

    _townController.text = pMark.locality;
    _landmarkController.text = pMark.locality;
    //_stateController.text = pMark.administrativeArea;
    _housenumberController.text = pMark.street;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final addressId = ModalRoute.of(context)!.settings.arguments as String;
    // print('add' + addressId);
    Size size = MediaQuery.of(context).size;

    // final addAddress = Provider.of<AddressProvider>(context);
    final loading = Provider.of<AddressProvider>(context);
    // print('sush' + editAddress.id + 'sushalt');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: CustomColor.blackcolor,
            )),
        title: Text(editAddress.id == '' ? 'Add Address' : 'Edit Address'),
        // actions: [Text(finalAddress)],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height * 0.065,
                  child: ElevatedButton(
                    child: const Text('Use My Current Location'),
                    onPressed: () {
                      CurrentLocation().determinePosition();
                      getCurrentLocation();
                      isvisible = true;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('Full Name'),
                    Container(
                      height: size.height * 0.065,
                      decoration: BoxDecoration(
                          color: CustomColor.grey100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                    primary: CustomColor.orangecolor,
                                  )),
                          child: personName()),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title('Phone Number'),
                            Container(
                              height: size.height * 0.065,
                              decoration: BoxDecoration(
                                  color: CustomColor.grey100,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Theme(
                                  data: Theme.of(context).copyWith(
                                      colorScheme: ThemeData()
                                          .colorScheme
                                          .copyWith(
                                            primary: CustomColor.orangecolor,
                                          )),
                                  child: phoneNumber()),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title('Pincode'),
                            Container(
                              height: size.height * 0.065,
                              decoration: BoxDecoration(
                                  color: CustomColor.grey100,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Theme(
                                  data: Theme.of(context).copyWith(
                                      colorScheme: ThemeData()
                                          .colorScheme
                                          .copyWith(
                                            primary: CustomColor.orangecolor,
                                          )),
                                  child: pincode()),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('Flat,House no,Building,Company'),
                    Container(
                      height: size.height * 0.065,
                      decoration: BoxDecoration(
                          color: CustomColor.grey100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                    primary: CustomColor.orangecolor,
                                  )),
                          child: houseNumber()),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('Area,Street,Sector,Village'),
                    Container(
                      height: size.height * 0.065,
                      decoration: BoxDecoration(
                          color: CustomColor.grey100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                    primary: CustomColor.orangecolor,
                                  )),
                          child: arealocation()),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     title('Landmark ( Optional )'),
                //     Container(
                //       height: size.height * 0.065,
                //       decoration: BoxDecoration(
                //           color: CustomColor.grey100,
                //           borderRadius: BorderRadius.circular(10)),
                //       child: Theme(
                //           data: Theme.of(context).copyWith(
                //               colorScheme: ThemeData().colorScheme.copyWith(
                //                     primary: CustomColor.orangecolor,
                //                   )),
                //           child: landmark()),
                //     )
                //   ],
                // ),
                // SizedBox(
                //   height: size.height * 0.03,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('Town / City'),
                    Container(
                      height: size.height * 0.065,
                      decoration: BoxDecoration(
                          color: CustomColor.grey100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                    primary: CustomColor.orangecolor,
                                  )),
                          child: townCity()),
                    )
                  ],
                ),

                SizedBox(
                  height: size.height * 0.03,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('Country'),
                   // isvisible == false
                         Container(
                            height: size.height * 0.065,
                            decoration: BoxDecoration(
                                color: CustomColor.grey100,
                                borderRadius: BorderRadius.circular(10)),
                            child: Theme(
                                data: Theme.of(context).copyWith(
                                    colorScheme:
                                        ThemeData().colorScheme.copyWith(
                                              primary: CustomColor.blackcolor,
                                              secondary: CustomColor.blackcolor, 
                                            )),
                               // child: CountryDropdown(context)),
                               child: loading.isLoading ?
                               Center(child: CircularProgressIndicator(color: CustomColor.orangecolor,),):Container(
                                child:CountryDropdown(context),
                               ))
                          )
                        // : Container(
                        //     child: Theme(
                        //         data: Theme.of(context).copyWith(
                        //             colorScheme: ThemeData()
                        //                 .colorScheme
                        //                 .copyWith(
                        //                     primary: CustomColor.orangecolor)),
                        //         child: CountryText())
                            // Container(
                            //   height: size.height * 0.065,
                            //   decoration: BoxDecoration(
                            //       color: CustomColor.grey100,
                            //       borderRadius: BorderRadius.circular(10)),
                            //   child: TextFormField(
                            //     controller: _countryController,
                            //     // initialValue: iniValue['name'],
                            //     style: CustomThemeData().clearStyle(),
                            //     textInputAction: TextInputAction.next,
                            //     keyboardType: TextInputType.text,
                            //     decoration: const InputDecoration(
                            //         labelStyle: TextStyle(
                            //             color: CustomColor.orangecolor),
                            //         hintText: 'Country',
                            //         border: InputBorder.none,
                            //         focusedBorder: InputBorder.none,
                            //         prefixIcon: Icon(
                            //           Icons.location_city,
                            //         )),

                            //     validator: (value) {
                            //       if (value.isEmpty) {
                            //         return _services.customDialog(context,
                            //             'Country', 'Please add your Country');
                            //       }
                            //       return null;
                            //     },
                            //     onSaved: (value) {
                            //       editAddress = Addresss(
                            //           id: editAddress.id,
                            //           name: editAddress.name,
                            //           phoneNumber: editAddress.phoneNumber,
                            //           pincode: editAddress.pincode,
                            //           houseNumber: editAddress.houseNumber,
                            //           area: editAddress.area,
                            //           landmark: editAddress.landmark,
                            //           town: editAddress.town,
                            //           countryId: editAddress.countryId,
                            //           country: editAddress.country,
                            //           stateId: editAddress.stateId,
                            //           state: editAddress.state,
                            //           addresstype: editAddress.addresstype);
                            //     },
                            //     // onChanged: (val) {
                            //     //   val = _nameController.text.toString();
                            //     // },
                            //   ),
                            // ),
                          //  ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     title('State'),
                //     Container(
                //       height: size.height * 0.065,
                //       decoration: BoxDecoration(
                //           color: CustomColor.grey100,
                //           borderRadius: BorderRadius.circular(10)),
                //       child: Theme(
                //           data: Theme.of(context).copyWith(
                //               colorScheme: ThemeData().colorScheme.copyWith(
                //                     primary: CustomColor.orangecolor,
                //                   )),
                //           child: addressType(context)),
                //     )
                //   ],
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('State'),
                    //isvisible == false
                        //?
                        Container(
                            height: size.height * 0.065,
                            decoration: BoxDecoration(
                                color: CustomColor.grey100,
                                borderRadius: BorderRadius.circular(10)),
                            child: Theme(
                                data: Theme.of(context).copyWith(
                                    colorScheme:
                                        ThemeData().colorScheme.copyWith(
                                              primary: CustomColor.blackcolor,
                                              secondary: CustomColor.blackcolor
                                            )),
                              //  child: stateDropdown(context)),
                              child: loading.isLoading?
                              Center(child: CircularProgressIndicator(color: CustomColor.orangecolor),):Container(
                                child: stateDropdown(context)),
                              ),
                          )
                        // : Container(
                        //     child: Theme(
                        //         data: Theme.of(context).copyWith(
                        //             colorScheme: ThemeData()
                        //                 .colorScheme
                        //                 .copyWith(
                        //                     primary: CustomColor.orangecolor)),
                        //         child: StateText())

                            //  Container(
                            //   height: size.height * 0.065,
                            //   decoration: BoxDecoration(
                            //       color: CustomColor.grey100,
                            //       borderRadius: BorderRadius.circular(10)),
                            //   child: TextFormField(
                            //     controller: _stateController,
                            //     // initialValue: iniValue['name'],
                            //     style: CustomThemeData().clearStyle(),
                            //     textInputAction: TextInputAction.next,
                            //     keyboardType: TextInputType.text,
                            //     decoration: const InputDecoration(
                            //         hintText: 'State',
                            //         border: InputBorder.none,
                            //         fillColor: CustomColor.orangecolor,
                            //         focusedBorder: InputBorder.none,
                            //         prefixIcon: Icon(
                            //           Icons.location_city,
                            //         )),
                            //     validator: (value) {
                            //       if (value.isEmpty) {
                            //         return _services.customDialog(context,
                            //             'State', 'Please add your State');
                            //       }
                            //       return null;
                            //     },
                            //     onSaved: (value) {
                            //       editAddress = Addresss(
                            //           id: editAddress.id,
                            //           name: editAddress.name,
                            //           phoneNumber: editAddress.phoneNumber,
                            //           pincode: editAddress.pincode,
                            //           houseNumber: editAddress.houseNumber,
                            //           area: editAddress.area,
                            //           landmark: editAddress.landmark,
                            //           town: editAddress.town,
                            //           countryId: editAddress.countryId,
                            //           country: editAddress.country,
                            //           stateId: editAddress.stateId,
                            //           state: editAddress.state,
                            //           addresstype: editAddress.addresstype);
                            //     },
                            //     // onChanged: (val) {
                            //     //   val = _nameController.text.toString();
                            //     // },
                            //   ),
                            // ),
                          //  )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title('Select Address Type'),
                    Container(
                      height: size.height * 0.065,
                      decoration: BoxDecoration(
                          color: CustomColor.grey100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                    primary: CustomColor.orangecolor,
                                  )),
                          child: addressType(context)),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                SizedBox(
                  width: size.width,
                  height: size.height * 0.065,
                  child: ElevatedButton(
                    child: Text(
                      editAddress.id == '' ? 'Save Address' : 'Edit Address',
                    ),
                    onPressed: () {
                      submit();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget title(String text) {
    return Text(
      text,
      style: const TextStyle(color: CustomColor.blackcolor, fontSize: 13),
    );
  }

  Widget personName() {
    return TextFormField(
      controller: _nameController,
      // initialValue: iniValue['name'],
      style: CustomThemeData().clearStyle(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          hintText: 'Full Name',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(
            Icons.person_outline,
          )),
      validator: (value) {
        if (value.isEmpty) {
          return _services.customDialog(
              context, 'Full Name', 'Please add your Name');
        }
        return null;
      },
      onSaved: (value) {
        editAddress = Addresss(
            id: editAddress.id,
            name: value.toString(),
            phoneNumber: editAddress.phoneNumber,
            pincode: editAddress.pincode,
            houseNumber: editAddress.houseNumber,
            area: editAddress.area,
            // landmark: editAddress.landmark,
            town: editAddress.town,
            countryId: countryId,
            country: editAddress.country,
            stateId: stateId,
            state: editAddress.state,
            addresstype: editAddress.addresstype);
      },
      // onChanged: (val) {
      //   val = _nameController.text.toString();
      // },
    );
  }

  Widget phoneNumber() {
    return TextFormField(
      controller: _phonenumber,
      // initialValue: iniValue['phonenumber'],
      style: CustomThemeData().clearStyle(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      ],
      decoration: const InputDecoration(
          hintText: 'Phone Number',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(
            Icons.person_outline,
          )),
      validator: (value) {
        if (value.isEmpty) {
          return _services.customDialog(
              context, 'Phone Number', 'Please add your Phone Number');
        } else if (value.length != 10) {
          return _services.customDialog(context, 'Phone Number',
              'Please enter your correct mobile number');
        }
        return null;
      },
      onSaved: (value) {
        editAddress = Addresss(
            id: editAddress.id,
            name: editAddress.name,
            phoneNumber: value.toString(),
            pincode: editAddress.pincode,
            houseNumber: editAddress.houseNumber,
            area: editAddress.area,
            // landmark: editAddress.landmark,
            town: editAddress.town,
            countryId: countryId,
            country: editAddress.country,
            stateId: stateId,
            state: editAddress.state,
            addresstype: editAddress.addresstype);
      },
      // onChanged: (val) {
      //   val = _phonenumber.text;
      // },
    );
  }

  Widget pincode() {
    return TextFormField(
      controller: _pincodeController,
      // initialValue: iniValue['pincode'],
      style: CustomThemeData().clearStyle(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      ],
      decoration: const InputDecoration(
          hintText: 'Pincode',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(
            Icons.location_on_outlined,
          )),
      validator: (value) {
        if (value.isEmpty) {
          return _services.customDialog(
              context, 'Pincode', 'Please add your Pincode');
        } else if (value.length != 6) {
          return _services.customDialog(
              context, 'Pincode', 'Please enter your correct Pincode');
        }
        return null;
      },
      onSaved: (value) {
        editAddress = Addresss(
            id: editAddress.id,
            name: editAddress.name,
            phoneNumber: editAddress.phoneNumber,
            pincode: value.toString(),
            houseNumber: editAddress.houseNumber,
            area: editAddress.area,
            // landmark: editAddress.landmark,
            town: editAddress.town,
            countryId: countryId,
            country: editAddress.country,
            stateId: stateId,
            state: editAddress.state,
            addresstype: editAddress.addresstype);
      },
      // onChanged: (val) {
      //   val = _pincodeController.text;
      // },
    );
  }

  Widget houseNumber() {
    return TextFormField(
      // initialValue: iniValue['housenumber'],
      controller: _housenumberController,
      style: CustomThemeData().clearStyle(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          hintText: 'Flat,House no,Building,Company',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(
            Icons.home_outlined,
          )),
      validator: (value) {
        if (value.isEmpty) {
          return _services.customDialog(context, 'House/ Companyname',
              'Please enter your House or Companyname');
        }
        return null;
      },
      onSaved: (value) {
        editAddress = Addresss(
            id: editAddress.id,
            name: editAddress.name,
            phoneNumber: editAddress.phoneNumber,
            pincode: editAddress.pincode,
            houseNumber: value.toString(),
            area: editAddress.area,
            // landmark: editAddress.landmark,
            town: editAddress.town,
            countryId: countryId,
            country: editAddress.country,
            stateId: stateId,
            state: editAddress.state,
            addresstype: editAddress.addresstype);
      },
      // onChanged: (val) {
      //   val = _housenumberController.text.toString();
      // },
    );
  }

  Widget arealocation() {
    return TextFormField(
      // initialValue: iniValue['area'],
      controller: _areaController,
      style: CustomThemeData().clearStyle(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          hintText: 'Area,Street,Sector,Village',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(
            Icons.location_city,
          )),
      validator: (value) {
        if (value.isEmpty) {
          return _services.customDialog(
              context, 'Area,Street', 'Please enter your Area or Street');
        }
        return null;
      },
      onSaved: (value) {
        editAddress = Addresss(
            id: editAddress.id,
            name: editAddress.name,
            phoneNumber: editAddress.phoneNumber,
            pincode: editAddress.pincode,
            houseNumber: editAddress.houseNumber,
            area: value.toString(),
            // landmark: editAddress.landmark,
            town: editAddress.town,
            countryId: countryId,
            country: editAddress.country,
            stateId:stateId,
            state: editAddress.state,
            addresstype: editAddress.addresstype);
      },
      // onChanged: (val) {
      //   val = _areaController.text.toString();
      // },
    );
  }

  Widget landmark() {
    return TextFormField(
      // initialValue: iniValue['landmark'],
      controller: _landmarkController,
      style: CustomThemeData().clearStyle(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          hintText: 'e.g Near apollo hospital',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(
            Icons.landscape_outlined,
          )),
      onSaved: (value) {
        editAddress = Addresss(
            id: editAddress.id,
            name: editAddress.name,
            phoneNumber: editAddress.phoneNumber,
            pincode: editAddress.pincode,
            houseNumber: editAddress.houseNumber,
            area: editAddress.area,
            // landmark: value.toString(),
            town: editAddress.town,
            countryId: countryId,
            country: editAddress.country,
            stateId: stateId,
            state: editAddress.state,
            addresstype: editAddress.addresstype);
      },
      // onChanged: (val) {
      //   val = _landmarkController.text.toString();
      // },
    );
  }

  Widget townCity() {
    return TextFormField(
      controller: _townController,
      // initialValue: iniValue['town'],
      style: CustomThemeData().clearStyle(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          hintText: 'Town / City',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(
            Icons.location_city_outlined,
          )),
      // onChanged: (val) {
      //   val = _townController.text.toString();
      // },
      validator: (value) {
        if (value.isEmpty) {
          return _services.customDialog(
              context, 'Town or City', 'Please enter your Town or City');
        }
        return null;
      },
      onSaved: (value) {
        editAddress = Addresss(
            id: editAddress.id,
            name: editAddress.name,
            phoneNumber: editAddress.phoneNumber,
            pincode: editAddress.pincode,
            houseNumber: editAddress.houseNumber,
            area: editAddress.area,
            // landmark: editAddress.landmark,
            town: value.toString(),
            countryId: countryId,
            country: editAddress.country,
            state: editAddress.state,
            stateId: stateId,
            addresstype: editAddress.addresstype);
      },
    );
  }

  // Widget StateText() {
  //   Size size = MediaQuery.of(context).size;
  //   return Container(
  //     height: size.height * 0.065,
  //     decoration: BoxDecoration(
  //         color: CustomColor.grey100, borderRadius: BorderRadius.circular(10)),
  //     child: TextFormField(
  //       controller: _stateIdController,
  //       // initialValue: iniValue['town'],
  //       style: CustomThemeData().clearStyle(),
  //       textInputAction: TextInputAction.next,
  //       keyboardType: TextInputType.emailAddress,
  //       decoration: const InputDecoration(
  //           hintText: 'State',
  //           border: InputBorder.none,
  //           focusedBorder: InputBorder.none,
  //           prefixIcon: Icon(
  //             Icons.location_city_outlined,
  //           )),
  //       // onChanged: (val) {
  //       //   val = _townController.text.toString();
  //       // },
  //       validator: (value) {
  //         if (value.isEmpty) {
  //           return _services.customDialog(
  //               context, 'State', 'Please enter your State');
  //         }
  //         return null;
  //       },
  //       onSaved: (value) {
  //         editAddress = Addresss(
  //             id: editAddress.id,
  //             name: editAddress.name,
  //             phoneNumber: editAddress.phoneNumber,
  //             pincode: editAddress.pincode,
  //             houseNumber: editAddress.houseNumber,
  //             area: editAddress.area,
              // landmark: editAddress.landmark,
  //             town: editAddress.town,
  //             countryId: editAddress.countryId,
  //             country: editAddress.country,
  //             state:editAddress.state,
  //             stateId: value.toString(),
  //             addresstype: editAddress.addresstype);
  //       },
  //     ),
  //   );
  // }

  // Widget CountryText() {
  //   Size size = MediaQuery.of(context).size;
  //   return Container(
  //     height: size.height * 0.065,
  //     decoration: BoxDecoration(
  //         color: CustomColor.grey100, borderRadius: BorderRadius.circular(10)),
  //     child: TextFormField(
  //       controller: _countryIdController,
  //       // initialValue: iniValue['town'],
  //       style: CustomThemeData().clearStyle(),
  //       readOnly: true,
  //       textInputAction: TextInputAction.next,
  //       keyboardType: TextInputType.emailAddress,
  //       decoration: const InputDecoration(
  //           hintText: 'Country',
  //           border: InputBorder.none,
  //           focusedBorder: InputBorder.none,
  //           prefixIcon: Icon(
  //             Icons.location_city_outlined,
  //           )),
  //       // onChanged: (val) {
  //       //   val = _townController.text.toString();
  //       // },
  //       validator: (value) {
  //         if (value.isEmpty) {
  //           return _services.customDialog(
  //               context, 'State', 'Please enter your Country');
  //         }
  //         return null;
  //       },
  //       onSaved: (value) {
  //         editAddress = Addresss(
  //             id: editAddress.id,
  //             name: editAddress.name,
  //             phoneNumber: editAddress.phoneNumber,
  //             pincode: editAddress.pincode,
  //             houseNumber: editAddress.houseNumber,
  //             area: editAddress.area,
              // landmark: editAddress.landmark,
  //             town: editAddress.town,
  //             countryId:value.toString(),
  //             country:editAddress.country,
  //             state: editAddress.state,
  //             stateId: editAddress.stateId,
  //             addresstype: editAddress.addresstype);
  //       },
  //     ),
  //   );
  // }

  Widget CountryDropdown(BuildContext context) {
    final data = Provider.of<AddressProvider>(context, listen: false);
    return DropdownSearch<String>(
       
        
        //selectedItem: CustomThemeData().clearStyle(),
        popupProps: PopupProps.menu(
          title:Text('Select a Country',style: TextStyle(color: CustomColor.blackcolor,fontSize: 13),),
             showSearchBox: true,
            showSelectedItems: true,
            
          

        
      
       
          
           ),
      
      selectedItem: editAddress.countryId == '' ? ' Select a Country': editAddress.country,
    
        
       dropdownDecoratorProps: DropDownDecoratorProps(
        
      
        baseStyle: TextStyle(fontSize: 13,color: CustomColor.blackcolor),
        dropdownSearchDecoration:
        InputDecoration(hintText: 'Select a Country',hintStyle: TextStyle(fontSize: 13),
        fillColor: CustomColor.blackcolor,
        prefixIcon:Icon(Icons.location_city),
        border: InputBorder.none,
        focusedBorder:InputBorder.none,
        
        
        ),

        ),
        dropdownButtonProps: DropdownButtonProps(color: CustomColor.blackcolor),
        
        
        onChanged: (String newValue){
          for(var i=0;i<data.countryDropDown.length;i++){

            if(newValue==data.countryDropDown[i].name){
             countryId = data.countryDropDown[i].id;
             setState(() {
               
             });
             
              // setState(() {
                
              // });
              print(countryId + '------>> country id');
              Provider.of<AddressProvider>(context,listen:false).stateDropDownField(
                apiName: "state_id",
                context: context,
                countryId: countryId,
                listAdd: data.stateDropDown,
                
              );
            }
           
          }
           print(countryId + '------>> country id outside');
          // setState(() {
          //   countryIdDropdown=newValue;
          //   print(countryIdDropdown);
          //   Provider.of<AddressProvider>(context,listen: false).stateDropDownField(
          //     apiName: "state_id",
          //     context: context,
          //     countryId: newValue,
          //     listAdd: data.stateDropDown
          

          //  );
          // });
          

          
        },
         validator: (value) {
        if (value.isEmpty) {
          return _services.customDialog(
              context, 'Country', 'Please enter your country');
        }
        return null;
      },
        onSaved:(value){
          
          editAddress = Addresss(
              id: editAddress.id,
              name: editAddress.name,
              phoneNumber: editAddress.phoneNumber,
              pincode: editAddress.pincode,
              houseNumber: editAddress.houseNumber,
              area: editAddress.area,
              // landmark: editAddress.landmark,
              town: editAddress.town,
              country: editAddress.country,
              
              countryId:countryId,
              //country: value.toString(),
              state: editAddress.state,
              stateId: stateId,
              addresstype: editAddress.addresstype);
        },
        
        items:data.countryDropDown.map((e)=>e.name).toList(),
        
        
          
        // items: data.countryDropDown.map((e) {
        //    e.id.toString();
        //       Text(
        //         e.name.toString(),
        //         overflow: TextOverflow.ellipsis,
        //       );
     
        // }
        
        // ).toList());
       );

 














       
        
        
       
    // return DropdownButtonFormField(
    //     style: CustomThemeData().clearStyle(),
    //     decoration: const InputDecoration(
    //         hintText: 'Select a country',
    //         hintStyle: TextStyle(fontSize: 13),
    //         prefixIcon: Icon(Icons.location_city_sharp),
    //         border: InputBorder.none,
    //         focusedBorder: InputBorder.none),
    //     dropdownColor: CustomColor.grey100,
    //     value: countryIdDropdown,
    //     onChanged: (String newValue)async {
    //       setState(() {
    //         countryIdDropdown = newValue;
    //         print(countryIdDropdown);
    //         Provider.of<AddressProvider>(context, listen: false)
    //             .stateDropDownField(
    //                 apiName: 'state_id',
    //                 context: context,
    //                 countryId: newValue,
    //                 listAdd: data.stateDropDown);
    //         print(newValue +'new value state');
    //       });
    //     },
    //     onSaved: (value) {
    //       editAddress = Addresss(
    //           id: editAddress.id,
    //           name: editAddress.name,
    //           phoneNumber: editAddress.phoneNumber,
    //           pincode: editAddress.pincode,
    //           houseNumber: editAddress.houseNumber,
    //           area: editAddress.area,
    //           // landmark: editAddress.landmark,
    //           town: editAddress.town,
    //           country: editAddress.country,
    //           countryId: value.toString(),
    //           //country: value.toString(),
    //           state: editAddress.state,
    //           stateId: editAddress.stateId,
    //           addresstype: editAddress.addresstype);
    //     },
    //     items: data.countryDropDown.map((e) {
    //       return DropdownMenuItem(
    //           value: e.id.toString(),
    //           child: Text(
    //             e.name.toString(),
    //             overflow: TextOverflow.ellipsis,
    //           ));
    //     }).toList());
  }

  Widget stateDropdown(BuildContext context) {
    final data = Provider.of<AddressProvider>(context, listen: false);
 
     

        return DropdownSearch<String>(
          
        
        //selectedItem: CustomThemeData().clearStyle(),
        popupProps: PopupProps.menu(
            title:Text('Select a State',style: TextStyle(color: CustomColor.blackcolor,fontSize: 13),),
            showSearchBox: true,
          showSelectedItems: true,
           ),
      selectedItem: editAddress.stateId== '' ? ' Select a State' : editAddress.state,
       dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: TextStyle(fontSize: 13),
        dropdownSearchDecoration:
        InputDecoration(hintText: 'Select a State',hintStyle:TextStyle(fontSize:13),
        fillColor: CustomColor.blackcolor,
        prefixIcon:Icon(Icons.location_city),
        border: InputBorder.none,
        focusedBorder:InputBorder.none
        ),
        ),
       
        onChanged: (String newValue){
          
           for(var i=0;i<data.stateDropDown.length;i++){

            if(newValue==data.stateDropDown[i].title){
             stateId=data.stateDropDown[i].id;
              // setState(() {
                
              // });
              print(stateId.toString() + '------>>state  id');
           
            }
          }
          
          // setState(() {
          //   stateIdDropdown=newValue;
          //   print(stateIdDropdown);
          // });
        
        },
            validator: (value) {
        if (value.isEmpty) {
          return _services.customDialog(
              context, 'State', 'Please enter your state');
        }
        return null;
      },
        
        onSaved:(value){
          editAddress = Addresss(
              id: editAddress.id,
              name: editAddress.name,
              phoneNumber: editAddress.phoneNumber,
              pincode: editAddress.pincode,
              houseNumber: editAddress.houseNumber,
              area: editAddress.area,
              // landmark: editAddress.landmark,
              town: editAddress.town,
              country: editAddress.country,
              countryId:countryId,
              //country: value.toString(),
              state: editAddress.state,
              stateId: stateId,
              addresstype: editAddress.addresstype);
        },

          items:data.stateDropDown.map((e)=>e.title).toList(),
        
        
 );
        
        
          
        // items: data.countryDropDown.map((e) {
        //    e.id.toString();
        //       Text(
        //         e.name.toString(),
        //         overflow: TextOverflow.ellipsis,
        //       );
     
      //   // }
        
        // ).toList());
      //  );











    // return DropdownButtonFormField(
    //     style: CustomThemeData().clearStyle(),
    //     decoration: const InputDecoration(
    //         hintText: 'Select a state',
    //         hintStyle: TextStyle(fontSize:13),
    //         prefixIcon: Icon(Icons.location_city),
    //         border: InputBorder.none,
    //         focusedBorder: InputBorder.none),
    //         dropdownColor: CustomColor.grey100,
    //         value: stateIdDropdown,
       
    //       onChanged: (String newValue) {
    //       setState(() {
    //         stateIdDropdown = newValue;
          
    //         print(stateIdDropdown);
    //       });
    //     },
    //     onSaved: (value) {
    //       editAddress = Addresss(
    //           id: editAddress.id,
    //           name: editAddress.name,
    //           phoneNumber: editAddress.phoneNumber,
    //           pincode: editAddress.pincode,
    //           houseNumber: editAddress.houseNumber,
    //           area: editAddress.area,
    //           // landmark: editAddress.landmark,
    //           town: editAddress.town,
    //           country: editAddress.country,
    //           countryId: editAddress.countryId,
    //           state: editAddress.state,
    //           stateId: value.toString(),
    //           addresstype: editAddress.addresstype);
    //     },
    //     items: data.stateDropDown.map((e) {
    //       return DropdownMenuItem(
    //           value: e.id.toString(),
    //           child: Text(
    //             e.title.toString(),
    //             overflow: TextOverflow.ellipsis,
    //           ));
    //     }).toList());
  }
  

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        child: Text(
          "private",
          style: CustomThemeData().clearStyle(),
        ),
        value: "private",
      ),
      DropdownMenuItem(
        child: Text(
          "delivery",
          style: CustomThemeData().clearStyle(),
        ),
        value: "delivery",
      ),
      DropdownMenuItem(
        child: Text(
          "invoice",
          style: CustomThemeData().clearStyle(),
        ),
        value: "invoice",
      ),
      DropdownMenuItem(
          child: Text(
            "contact",
            style: CustomThemeData().clearStyle(),
          ),
          value: "contact"),
      DropdownMenuItem(
          child: Text(
            "other",
            style: CustomThemeData().clearStyle(),
          ),
          value: "other"),
    ];
    return menuItems;
  }

  Widget addressType(BuildContext context) {
    return DropdownButtonFormField(
        style: CustomThemeData().clearStyle(),
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.location_city_outlined),
            border: InputBorder.none,
            focusedBorder: InputBorder.none),
        dropdownColor: CustomColor.grey100,
       value: editAddress.name == '' ? selectedValue : editAddress.addresstype,
        onChanged: (String newValue) {
          setState(() {
            selectedValue = newValue;
          });
        },
        onSaved: (value) {
          editAddress = Addresss(
              id: editAddress.id,
              name: editAddress.name,
              phoneNumber: editAddress.phoneNumber,
              pincode: editAddress.pincode,
              houseNumber: editAddress.houseNumber,
              area: editAddress.area,
              // landmark: editAddress.landmark,
              town: editAddress.town,
              country: editAddress.country,
              countryId: countryId,
              stateId: stateId,
              state: editAddress.state,
              addresstype: value.toString());
        },
        items: dropdownItems);
  }
}
