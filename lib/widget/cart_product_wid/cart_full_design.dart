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
import 'package:food_app/screen/manage_address/add_address.dart';

import 'package:food_app/services/dialogbox.dart';
import 'package:food_app/services/payment/stripe_payment.dart';

import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

import 'cart_product_design.dart';

class CartScreenDesign extends StatefulWidget {
  const CartScreenDesign({
    Key key,
  }) : super(key: key);

  @override
  State<CartScreenDesign> createState() => _CartScreenDesignState();
}

class _CartScreenDesignState extends State<CartScreenDesign> {
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
    final product = Provider.of<ProductProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
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
                  margin: const EdgeInsets.all(4),
                  width: size.width * 0.4,
                  // height: size.height,
                  // height: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: selectedAddress == address[index]
                              ? CustomColor.orangecolor
                              : CustomColor.whitecolor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SizedBox(
                        width: size.width * 0.6,
                        height: size.height * 0.3,
                        child: Card(
                            margin: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  address[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Text(
                                  address[index].houseNumber,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                Text(
                                  address[index].area,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                Text(
                                  address[index].phoneNumber,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                Text(
                                  address[index].state,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            )),
                      ),
                      Radio(
                          activeColor: CustomColor.orangecolor,
                          value: address[index],
                          groupValue: selectedAddress,
                          onChanged: (val) {
                            setState(() {
                              selectedAddress = val;
                            });
                            // print(selectedAddress.toString());
                          }),
                    ],
                  ),
                ),
              ))
        ..add(_seeMoreAddress());
      return SizedBox(
          height: size.height * 0.20,
          width: size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: addressWidget,
          ));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery To :',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                address.isEmpty
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AddAddressScreen.routeName);
                        },
                        child: Shimmer.fromColors(
                          baseColor: CustomColor.orangecolor,
                          highlightColor:
                              CustomColor.orangecolor.withOpacity(0.4),
                          child: Text(
                            'Click to add your Address',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ))
                    : Column(
                        children: List.generate(
                          address.isEmpty ? 0 : 1,
                          (index) => Text(
                            selectedAddress.name +
                                    ',' +
                                    selectedAddress.houseNumber +
                                    ',' +
                                    selectedAddress.area +
                                    ',' +
                                    selectedAddress.pincode +
                                    ',' +
                                    selectedAddress.phoneNumber +
                                    ',' +
                                    selectedAddress.town ??
                                'null'
                                        ',' +
                                    selectedAddress.state ??
                                'null'
                                        ',' +
                                    selectedAddress.addresstype ??
                                'Please select the address',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      )
              ],
            ),
          ),
          address.isEmpty
              ? const Text('Their is no address to be selected')
              : addressWid(),
          AnimationLimiter(
              child: Column(
            children: List.generate(
                data.cartTotalProductdata.length,
                (index) => AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 300),
                      child: ScaleAnimation(
                        duration: const Duration(milliseconds: 300),
                        child: FadeInAnimation(
                            duration: const Duration(milliseconds: 300),
                            child: ChangeNotifierProvider.value(
                                value:
                                    data.cartTotalProductdata.toList()[index],
                                child: CartProductDesign(
                                  index: index,
                                  productId:
                                      data.cartTotalProductdata[index].id,
                                  screenRefresh: screenRefresh,
                                ))),
                      ),
                    )),
          )),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Check Delivery'),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      checkDelivery = !checkDelivery;
                    });
                    Timer(Duration(seconds: 1), () {
                      if (checkDelivery == true) {
                        final data =
                            Provider.of<CartProvider>(context, listen: false);
                        int quantity = 0;
                        List<String> prodId = [];
                        for (var i = 0; i < data.cartproduct.length; i++) {
                          quantity += data.cartproduct[i].quantity;

                          prodId.add(data.cartproduct[i].id);
                        }
                        data.deliverycharge.toString();

                        data.finalDeliveryCharge(
                            productIds: prodId.toString(),
                            totalQuantity: quantity.toString(),
                            totalPrice: data.totalprice);
                        print(data.finalDeliveryCharge(
                            productIds: prodId.toString(),
                            totalQuantity: quantity.toString(),
                            totalPrice: data.totalprice));
                      } else {
                        data.deliverycharge = '0.0';
                        setState(() {});
                      }
                    });
                  },
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: CustomColor.orangecolor),
                          color: checkDelivery
                              ? CustomColor.orangecolor
                              : Colors.white),
                      child: checkDelivery
                          ? Center(
                              child: Icon(
                              Icons.done,
                              color: CustomColor.whitecolor,
                            ))
                          : Container()),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  address.isEmpty
                      ? ''
                      : checkDelivery
                          ? 'Delivery Charge'
                          : '',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('₹ ' + data.deliverycharge.toString(),
                    style: Theme.of(context).textTheme.subtitle2),
              )
            ],
          ),
          // total > 500
          //     ? Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           children: [
          //             Card(
          //                 color: CustomColor.greencolor,
          //                 shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(50)),
          //                 child: const Icon(
          //                   Icons.done,
          //                   size: 20,
          //                   color: CustomColor.whitecolor,
          //                 )),
          //             Text(
          //               'Total Charges',
          //               style: Theme.of(context).textTheme.subtitle2,
          //             ),
          //               const Spacer(),
          //             Text('₹ ' + data.shippingcharge.toString())
          //           ],
          //         ),
          //       )
          //     : Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           children: [
          //             Card(
          //                 color: CustomColor.greencolor,
          //                 shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(50)),
          //                 child: const Icon(
          //                   Icons.done,
          //                   size: 20,
          //                   color: CustomColor.whitecolor,
          //                 )),
          //             Text(
          //               'Delivery Charge',
          //               style: Theme.of(context).textTheme.subtitle2,
          //             ),
          //             const Spacer(),
          //             Text('₹ ' + data.shippingcharge.toString())
          //           ],
          //         ),
          //       ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Item Total',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      '₹' + data.totalAmount.toString(),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Taxes & charges',
                //       style: Theme.of(context).textTheme.subtitle2,
                //     ),
                //     Text(
                //       '₹' + data.totalTax.toString(),
                //       style: Theme.of(context).textTheme.subtitle2,
                //     )
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Additional Charge',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      '₹' + data.alltotaladditionalcharge.toString(),
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                  ],
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Delivery charges',
                //       style: Theme.of(context).textTheme.subtitle2,
                //     ),
                //     Text(
                //       '₹' + data.shippingcharge.toString(),
                //       style: Theme.of(context).textTheme.subtitle2,
                //     )
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Grand Total',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      '₹' + data.totalprice,
                      style: Theme.of(context).textTheme.bodyText2,
                    )
                  ],
                ),
                const Divider(
                  color: CustomColor.grey200,
                ),
                Container(
                    width: size.width,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Your Payment Method',
                      style: Theme.of(context).textTheme.subtitle1,
                    )),
                ListTile(
                  onTap: () {
                    setState(() {
                      offlinepayment = true;
                      onlinepayment = false;
                    });
                  },
                  leading: Image.asset(
                    CustomImages.cashonDelivery,
                    width: size.width * 0.1,
                    height: size.height * 0.05,
                  ),
                  title: Text(
                    'Cash on Delivery',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  trailing: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: offlinepayment == true
                              ? CustomColor.orangecolor
                              : CustomColor.grey300,
                        ),
                        color: CustomColor.whitecolor,
                        shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CircleAvatar(
                        backgroundColor: offlinepayment == true
                            ? CustomColor.orangecolor
                            : CustomColor.grey300,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      onlinepayment = true;
                      offlinepayment = false;
                    });
                  },
                  leading: Image.asset(
                    CustomImages.onlinePayment,
                    width: size.width * 0.1,
                    height: size.height * 0.05,
                  ),
                  title: Text(
                    'pay with card',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  trailing: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: onlinepayment == true
                              ? CustomColor.orangecolor
                              : CustomColor.grey300,
                        ),
                        color: CustomColor.whitecolor,
                        shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CircleAvatar(
                        backgroundColor: onlinepayment == true
                            ? CustomColor.orangecolor
                            : CustomColor.grey300,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width,
                  height: size.height * 0.065,
                  child: ElevatedButton(
                      onPressed: () {
                        product.productpagerefresh();
                        if (address.isEmpty) {
                          _services.addressDialog(
                              context: context,
                              title: 'Address Empty',
                              content: 'Please add your Address');
                        } else {
                          if (checkDelivery == true) {
                            if (onlinepayment == true) {
                              //  print('sushalt ::' + data.totalprice.toString() );
                              paywithcard(data.totalprice.toString());
                            } else if (offlinepayment == true) {
                              cashOnDelivery(data.totalprice.toString());
                            }
                          }
                        }
                      },
                      child: Text(address.isEmpty
                          ? 'Select Your Address'
                          : checkDelivery
                              ? 'Check Out'
                              : 'Select Delivery Charge')),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
