// ignore_for_file: unnecessary_string_escapes

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_app/const/color_const.dart';
import 'package:food_app/const/images.dart';
import 'package:food_app/models/address/address.dart';
import 'package:food_app/provider/address/address_provider.dart';
import 'package:food_app/provider/cart_provider.dart';
import 'package:food_app/provider/order_provider.dart';
import 'package:food_app/provider/product_provider.dart';
import 'package:food_app/screen/cart_screen/cart_screen.dart';
import 'package:food_app/screen/manage_address/add_address.dart';

import 'package:food_app/services/dialogbox.dart';
import 'package:food_app/services/payment/stripe_payment.dart';
import 'package:food_app/widget/cart_product_wid/cart_full_design.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

Addresss selectaddressvalue;

class SelecteAddressScreen extends StatefulWidget {
  const SelecteAddressScreen({
    Key key,
  }) : super(key: key);
  static const routeName = 'selectaddress_screen_design';

  @override
  State<SelecteAddressScreen> createState() => _SelecteAddressScreenState();
}

class _SelecteAddressScreenState extends State<SelecteAddressScreen> {
  // const CartScreenDesign({Key? key}) : super(key: key);

  Addresss selectedAddress;
  bool onlinepayment = true;
  bool offlinepayment = false;
  bool screenRefresh = false;
  Timer timer;
  bool checkDelivery = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {});
      }
    });

    final address = Provider.of<AddressProvider>(context).address;

    address.isEmpty ? selectedAddress = null : selectedAddress = address[0];

    // selectedAddress = address[0];
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  Future<void> orderApiCall() async {
    print('start data + -->');

    final data = Provider.of<CartProvider>(context, listen: false);
    final cartproduct = data.cartproduct;
    final cartTotalProduct = data;
    List<String> listLineItem = [];
    List<String> cartExtraValue = [];
    var order = Provider.of<OrderProvider>(context, listen: false);
    String lineItem = 'gdhd';
    String cartAddi = '';

    // print('selected address id + ' + selectedAddress.id);
    String addressdetails = selectedAddress.name +
        ',' +
        selectedAddress.houseNumber +
        ',' +
        selectedAddress.area +
        ',' +
        selectedAddress.pincode +
        ',' +
        selectedAddress.phoneNumber +
        ',' +
        selectedAddress.town +
        ',' +
        selectedAddress.state +
        ',' +
        selectedAddress.addresstype;

    for (var i = 0; i < cartproduct.length; i++) {
      lineItem =
          '{"price\": \"${cartproduct[i].price}\", \"discount\": \"0\", \"productid\": \"${cartproduct[i].id}\", \"quantity\": \"${cartproduct[i].quantity}\",\"productName\": \"${cartproduct[i].title}\"}';
      for (var j = 0;
          j < cartTotalProduct.cartTotalProductdata[i].cartCharge.length;
          j++) {
        if (cartTotalProduct.cartTotalProductdata[i].cartCharge[j].id == '') {
          print('product id data -->> $j');

          continue;
        }
        print(cartTotalProduct.cartTotalProductdata[i].cartCharge[j].id +
            'product id data sus $j');
        if (cartTotalProduct.cartTotalProductdata[i].cartCharge.isEmpty) {
          print('welcome welcome id empty -->' +
              cartTotalProduct.cartTotalProductdata[i].cartCharge[j].id);
          print('welcome welcome id empty');
        } else if (cartTotalProduct
                .cartTotalProductdata[i].cartCharge[j].name ==
            'summa') {
          print(cartTotalProduct.cartTotalProductdata[i].cartCharge[j].name +
              '---->> name');
          print(cartTotalProduct.cartTotalProductdata[i].cartCharge[j].price +
              '---->> price');
        } else {
          print('welcome welcome id not empty');
          print(cartTotalProduct.cartTotalProductdata[i].cartCharge[j].price +
              '-->> pricee');
          cartAddi =
              '{"price\": \"${cartTotalProduct.cartTotalProductdata[i].cartCharge[j].price}\", \"discount\": \"0\", \"productid\": \"${cartTotalProduct.cartTotalProductdata[i].cartCharge[j].id}\", \"quantity\": \"1\",\"productName\": \"${cartTotalProduct.cartTotalProductdata[i].cartCharge[j].name}\"}';
          cartExtraValue.add(cartAddi);
        }
      }
      // var newList = [lineItem + cartExtraValue];
      // print(newList);
      // // print(lineItem);

      // print(listLineItem);
      cartExtraValue.add(lineItem);
      // listLineItem.add(lineItem +
      //     ',' +
      //     cartExtraValue.toString().replaceAll("[", '').replaceAll("]", ''));
      // print(listLineItem.toString().replaceAll(',,', ','));
      print(cartExtraValue.toString());
    }
    // print('lineItem :: --> ${listLineItem.toString()}');
    // print(addressdetails + 'address data value');
    // print('address data value -->>' +
    //     selectedAddress.state +
    //     selectedAddress.addresstype);
    //uncommend this //
    order.postOrderApi(
        amount: data.totalAmount.toString(),
        grandTotal: data.totalprice.toString(),
        paymentType:
            onlinepayment == true ? 'Pay with Card' : 'Cash on delivery',
        shippingCharge: data.deliverycharge.toString(),
        addressId: selectedAddress.id,
        context: context,
        addressDetails: addressdetails,
        lineItem: cartExtraValue.toString());
  }

  final GlobalServices _services = GlobalServices();

  @override
  Widget build(BuildContext context) {
    // final cartaddress= Provider.of<Addresss>(context,listen: false);
    //  final cartId = ModalRoute.of(context).settings.arguments as String;
    // final order = Provider.of<OrderProvider>(context);
    final cart = Provider.of<CartProvider>(context, listen: false);
    // final cartData = cart.findById(cartId);
    // final cartaddress= Provider.of<Addresss>(context,listen: false);
    final product = Provider.of<ProductProvider>(context, listen: false);

    Size size = MediaQuery.of(context).size;
    Widget _seeMoreAddress() {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AddAddressScreen.routeName);
          },
          child: const CircleAvatar(
            backgroundColor: CustomColor.orangecolor,
            radius: 30,
            child: Icon(
              Icons.add,
              color: CustomColor.whitecolor,
            ),
          ));
    }

    final data = Provider.of<CartProvider>(context);
    // final cartproduct = data.cartproduct;
    // final total = data.totalAmount;
    final address = Provider.of<AddressProvider>(context).address;
    final fun = Provider.of<AddressProvider>(context);
    final charge = Provider.of<CartProvider>(context).cartCharges;

    void paywithcard(String amount) async {
      try {
        // ProgressDialog dialog = ProgressDialog(context: context);
        print('payment gate way started');
        await StripeServices.payment(amount).then((value) {
          orderApiCall().then((value) {
            // data.removeAllCartProd(context: context);
            data.removeAllCartProd(context: context);
          });
        });

        // Provider.of<OrderProvider>(context, listen: false)
        //     .addorder(
        //       cartproduct: data.cartproduct.toList(),
        //       amount: data.totalprice,
        //       id: '',
        //       grandtotal: data.totalprice,
        //       itemTotal: data.totalAmount,
        //       payment: 'Strip payment',
        //       shipping: data.shippingcharge,
        //       deliveryAddress: selectedAddress,
        //       deliveryStatus: 'Ordered',
        //     )
        //     ;

        // dialog.close();
        // Navigator.of(context).pushNamed(OrderScreen.routeName);

        // dialog.close();

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: const SizedBox(
        //       height: 40,
        //       child: Center(
        //         child: Text('payment successful'),
        //       ),
        //     ),

        //     margin: const EdgeInsets.all(10),
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //     backgroundColor: CustomColor.orangecolor,
        //     duration: const Duration(milliseconds: 2000),
        //     behavior: SnackBarBehavior.floating,
        //     //   action: SnackBarAction(
        //     //     textColor: CustomColor.whitecolor,
        //     //     label: 'View cart',
        //     //     onPressed: () {},
        //     //   ),
        //   ),
        // );
      } catch (error) {
        print(error.toString());
        // GlobalSnackBar().generalSnackbar(text: 'Something went worng');
      }
    }

    void cashOnDelivery(String amount) {
      orderApiCall().then((value) {
        // un commmend this line //
        data.removeAllCartProd(context: context);
        data.removeAllCartProd(
          context: context,
        );
      });
      // Provider.of<OrderProvider>(context, listen: false).addorder(
      //   cartproduct: data.cartproduct.toList(),
      //   amount: data.totalprice,
      //   id: '',
      //   grandtotal: data.totalprice,
      //   itemTotal: data.totalAmount,
      //   payment: 'Cash on delivery',
      //   shipping: data.shippingcharge,
      //   deliveryAddress: selectedAddress,
      //   deliveryStatus: 'Ordered',
      // );
    }

    Widget addressWid() {
      final addressWidget = List.generate(
          address.length,
          (index) => GestureDetector(
                onTap: null,
                child: Container(
                  margin: const EdgeInsets.all(15),
                  width: size.width * 0.4,
                  // height: size.height,
                  // height: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: selectedAddress == address[index]
                              ? CustomColor.orangecolor
                              : CustomColor.whitecolor),
                      borderRadius: BorderRadius.circular(0)),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SizedBox(
                        //jincy
                        width: size.width * 0.5,
                        height: size.height * 0.3,
                        child: Card(
                            margin: const EdgeInsets.all(0),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  // widget.address,

                                  address[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  //style: Theme.of(context).textTheme.,
                                ),
                                Text(
                                  address[index].houseNumber,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                  address[index].area,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                  address[index].phoneNumber,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  //style: Theme.of(context).textTheme.subtitle2,
                                  style: TextStyle(color: CustomColor.bluecolor,fontSize: 15,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  address[index].state,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ],
                            )),
                      ),
                      Radio(
                          activeColor: CustomColor.orangecolor,
                          value: address[index],
                          groupValue: fun.addressSingleData,
                          onChanged: (val) {
                            setState(() {});
                            fun.addressSingle(val);
                            print(fun.addressSingleData.id);
                          }),
                    ],
                  ),
                ),
              ));
      // ..add(_seeMoreAddress());
      return SizedBox(
          //Jincy
          height: size.height / 1.3,
          width: size.width,
          child: GridView(
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // childAspectRatio: 1 / 1.5,
                crossAxisSpacing: size.width * 0.02,
                mainAxisSpacing: size.height * 0.02),
            children: addressWidget,
            //  return addressWidget(),
            // child: GridView(
            //   scrollDirection: Axis.vertical,
            //   children: addressWidget,
            // )
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(' My Address'),
        centerTitle: true,
        actions: [
          // Center(
          //   child: Container(
          //     margin: const EdgeInsets.all(6),
          //     child: InkWell(
          //         onTap: () {
          //           alertBox();
          //         },
          //         child: ElevatedButton(
          //           child: Text(
          //             'Clear Cart',
          //             style: TextStyle(
          //                 color: CustomColor.whitecolor,
          //                 fontWeight: FontWeight.bold),
          //           ),
          //         )
          //         // Text(
          //         //   'Clear cart',
          //         //   style: CustomThemeData().clearStyle(),
          //         // ),
          //         ),
          //   ),
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addressWid(),
            SizedBox(
              height: size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _seeMoreAddress(),
                SizedBox(
                  height: size.height * 0.05,
                  width: size.width * 0.3,
                  child: ElevatedButton(
                    onPressed: () async {
                      // selectaddressvalue;
                      Navigator.pop(context);

                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => MyCartScreen(
                      //             productId: , value: selectaddressvalue)));
                    },
                    child: Text(
                      '   Done   ',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          CustomColor.orangecolor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getaddres({
    String name,
  }) {
    final addre = Navigator.of(context).pop();
  }
}
