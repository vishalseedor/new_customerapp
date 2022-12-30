import 'package:flutter/material.dart';

import '../const/color_const.dart';

class ClaimEmptyScreen extends StatelessWidget {
  const ClaimEmptyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delete_outline_outlined,
            color: CustomColor.orangecolor,
            size: size.height * 0.2,
          ),
          Container(
              margin: const EdgeInsets.all(10),
              child: const Text('No Claim details for this product')),
          Container(
              margin: const EdgeInsets.all(10),
              // child: Text(
              //   'Looks like you havent\'t Filter any product.',
              //   textAlign: TextAlign.center,
              //   style: Theme.of(context).textTheme.subtitle2,
              // )
              ),
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.of(context);
          //           //.pushReplacementNamed(FilterSCreen.routeName);
          //     },
          //   )
        ],
      ),
    );
  }
}
