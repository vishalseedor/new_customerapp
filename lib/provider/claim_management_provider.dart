import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_app/const/config.dart';
import 'package:food_app/models/claim.dart';
import 'package:food_app/provider/order_provider.dart';
import 'package:food_app/provider/shareprefes_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../services/snackbar.dart';
import 'package:http/http.dart' as http;

class ClaimManagementProvider with ChangeNotifier{
  bool _isLoading = false;
  bool get islOading {
    return _isLoading;
  }
  
// ClaimModel _claimModel;
// ClaimModel get claimModel{
//   return _claimModel;
// }
  
  // List<ClaimModel> _claimData = [];
  // List<ClaimModel> get claimData {
  //   return [..._claimData];
  // }

  GlobalSnackBar globalSnackBar = GlobalSnackBar();
   bool _loadingSpinner = false;
    bool get loadingSpinner {
    return _loadingSpinner;
  }

  bool _isSelect = false;

  bool get isSelect {
    return _isSelect;
  }
    bool _isError = false;

  bool get isError{
    return _isError;
  }
   List<ClaimModel> _claim = [];
   List<ClaimModel> get claim {
    return [..._claim];
  }
  

  Future  GetClaimManagementData({@required BuildContext context,@required String productid}) async {
    try{
       _loadingSpinner = true;
      // List<ClaimModel>_loadedData = [];
      var headers = {
     'Cookie': 'session_id=ad9b3d63d0f6e25ada8e6568cf58fa1a599002b9; session_id=7b0d4e758d373cce72309aab1c496ee01a0ebdb4; session_id=edf89d64260706656486a72ddbe1751e737f42a9'
};
  var response = await http.get(
          Uri.parse(
             
             "http://eiuat.seedors.com:8290/seedor-affinity/claims/get?clientid=bookseedorpremiumuat&fields={'claim_type','date','date_deadline','model_ref_id','description','priority','resolution','name','id'}&domain=[('model_ref_id','=','product.product,$productid')]"),

          headers: headers);
          print(
             
             "http://eiuat.seedors.com:8290/seedor-affinity/claims/get?clientid=bookseedorpremiumuat&fields={'claim_type','date','date_deadline','model_ref_id','description','priority','resolution','name','id'}&domain=[('model_ref_id','=','product.product,$productid')]");
             
             print(response.body);


          if (response.statusCode == 200) {
             _claim=[];
             var extractedData = json.decode(response.body);
             for(var i=0; i<extractedData.length;i++){
              _claim.add(ClaimModel(
                 id: extractedData[i]['id'].toString(), 
                 subject:extractedData[i]['name'].toString() ,
                 claimType: extractedData[i]['claim_type'][1].toString(), 
                 date: extractedData[i]['date'].toString(),
                 deadlineDate: extractedData[i]['date_deadline'].toString(), 
                 modelrefer:extractedData[i]['model_ref_id'].toString(),
                 priority: extractedData[i]['priority'].toString(), 
                 resolution:extractedData[i]['resolution'].toString(),
                 description: extractedData[i]['description'].toString()
                 ));
             


             }
             //_claim=_loadedData;
             _loadingSpinner=false;
              print('claim loading completed -->>');
              notifyListeners();
            

              //  _claimModel=ClaimModel(
              //   id: extractedData[0]['id'].toString(), 
              //   subject:extractedData[0]['name'].toString() ,
              //   claimType: extractedData[0]['claim_type'][1].toString(), 
              //   date: extractedData[0]['date'].toString(),
              //   deadlineDate: extractedData[0]['date_deadline'].toString(), 
              //   modelrefer:extractedData[0]['model_ref_id'].toString(),
              //    priority: extractedData[0]['priority'].toString(), 
              //    resolution:extractedData[0]['resolution'].toString(),
              //    description: extractedData[0]['description'].toString()
              //    );

            }else{
              _isError=true;
              
               globalSnackBar.generalSnackbar(
            context: context, text: 'Something went wrong');
        _loadingSpinner = false;
        notifyListeners();

            }
                  } 
      
  on HttpException catch (e) {
      print('error in product prod -->>' + e.toString());
     
      _loadingSpinner = false;
      _isSelect = false;
      notifyListeners();
      globalSnackBar.generalSnackbar(context: context, text: 'Something went wrong');
    }
 


}

  ClaimModel findById(String id) {
    return claim.firstWhere((element) => element.id == id);
  }




Future<void>PostClaimManagementdata({
  @required BuildContext context,
  @required String subject,
  //@required String claimtype,
  @required String description,
 // @required String priority,
  @required String partnerid,
  @required String email,
 @required String productId,

  
})async{
  try{
    final data = Provider.of<UserDetails>(context, listen: false);
     final order = Provider.of<OrderProvider>(context,listen: false);
     var headers = {
  'Content-Type': 'application/json',
  'Cookie': 'session_id=33312650586f7fb9b4f969e6223676a8ad4e95c9; session_id=edf89d64260706656486a72ddbe1751e737f42a9'
};
var body=json.encode({
     "clientid":client_id,
     "subject":subject,
     "claim_type":'Customer',
    "description":description,
    "priority":'2',
    "partner_id":data.id,
    "email":data.email,
    "productid":productId,
    });
    print(body);
       var response = await http.post(
          Uri.parse('http://eiuat.seedors.com:8290/seedor-affinity/claims/customer-claim'),
          headers: headers,
          body: body);
          print('http://eiuat.seedors.com:8290/seedor-affinity/claims/customer-claim');

        var jsonData = json.decode(response.body);
      print(jsonData);
       if (response.statusCode == 200){
        print(response.body);
      //await Provider.of<ClaimManagementProvider>(context,listen: true).GetClaimManagementData(context:context,productid: productId);
        Navigator.of(context).pop();
        
        
      } else {
        print(response.reasonPhrase);
      }
       return response.statusCode.toString();
       
  }catch (e) {
      print(e.toString());
      print(e.toString() + 'error in add fav post api');
    }


    








  



 
}

}