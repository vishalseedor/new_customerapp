import 'package:flutter/material.dart';
import 'package:food_app/const/color_const.dart';
import 'package:food_app/provider/claim_management_provider.dart';
import 'package:food_app/provider/order_provider.dart';
import 'package:food_app/screen/claim_emptyscreen.dart';
import 'package:food_app/screen/order/order_empty_screen.dart';
import 'package:food_app/services/snackbar.dart';
import 'package:food_app/widget/claim_design.dart';
import 'package:food_app/widget/order_wid/order_design.dart';
import 'package:provider/provider.dart';

class ClaimScreen extends StatefulWidget {
  static const routeName = 'claim-screen';
  const ClaimScreen({Key key}) : super(key: key);

  @override
  State<ClaimScreen> createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<ClaimScreen> {
  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
      GlobalSnackBar snackBar = GlobalSnackBar();
    
    final claim = Provider.of<ClaimManagementProvider>(context,listen: false);
    // product.update('address': null);

    // for (var i = 0; i <= product.values.toList()[i].cart.length; i++)
    // final loading = Provider.of<ClaimManagementProvider>(context);
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
          title: const Text('Claims'),
        ),
        body: claim.islOading
            ? const Center(
                child: CircularProgressIndicator(
                  color: CustomColor.orangecolor,
                ),
              )
            : claim.isError
            ?Container(child: Text(''),):
            claim.claim.isEmpty
                ? const ClaimEmptyScreen()
                : ListView.builder(
                  shrinkWrap: true,
                    itemCount: claim.claim.length,
                    itemBuilder: (context, index) {
                      //var val = product[index].cart;
                      return ChangeNotifierProvider.value(
                          value:claim.claim[index], child: const ClaimUiDesign());
                    }));
  }
}
