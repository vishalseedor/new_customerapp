import 'package:flutter/material.dart';
import 'package:food_app/const/color_const.dart';
import 'package:food_app/models/claim.dart';
import 'package:food_app/models/oder.dart';
import 'package:food_app/screen/get_claim_screen.dart';
import 'package:food_app/screen/order/order_details_screen/order_details_screen.dart';
import 'package:provider/provider.dart';


class ClaimUiDesign extends StatelessWidget {
  const ClaimUiDesign({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final claim = Provider.of<ClaimModel>(context);
    // final val = order.cart;
    // DateTime datetime = DateTime.now();
    // String datetime1 = DateFormat("yyyy-MM-dd").format(datetime);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(GetClaimManagementScreen.routeName,arguments: claim.id);
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
          
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(  'Subject : '+
                                  
                                  claim.subject),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                     // color: CustomColor.grey100,
                                      borderRadius: BorderRadius.circular(5)),
                                  // child: Text(
                                  //   'C',
                                  //   style: Theme.of(context).textTheme.caption,
                                  // ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Claim Type : ' +
                                      claim.claimType,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  'Date : ' +
                                     claim.date.substring(0,11),
                                  style: Theme.of(context).textTheme.headline4,
                                )
                              ],
                            ),
                          ],
                        )
                        ),
              ),
    );
            
           
  }
}
