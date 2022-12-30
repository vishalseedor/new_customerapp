import 'package:flutter/material.dart';
import 'package:food_app/const/color_const.dart';
import 'package:food_app/screen/claim_listview.dart';
import 'package:food_app/services/dialogbox.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../const/theme.dart';
import '../provider/claim_management_provider.dart';
import '../provider/order_provider.dart';

 class ClaimManagementScreen extends StatefulWidget {
  
    final String id;
  const ClaimManagementScreen({Key key,@required this.id}) : super(key: key);
   static const routeName = 'claim_management';

  @override
  State<ClaimManagementScreen> createState() => _ClaimManagementScreenState();
}

class _ClaimManagementScreenState extends State<ClaimManagementScreen> {
  bool isloading=false;
   final TextEditingController _subjectcontroller = TextEditingController();
   final TextEditingController _descriptioncontroller=TextEditingController();
    final GlobalServices _services = GlobalServices();
     final _formKey = GlobalKey<FormState>();


     @override
     void dispose(){
      super.dispose();
      _subjectcontroller.dispose();
      _descriptioncontroller.dispose();
     }

    void onsubmit() async {
      
   
  //  final isValid = _formKey.currentState.validate();
  //   if (!isValid) {
      
  //     return ;
  //   }
 if(_subjectcontroller.text.isEmpty){
      // ignore: void_checks
      return _services.customDialog(context,'Subject','Please enter your subject');

    }
    else if(_descriptioncontroller.text.isEmpty){
      // ignore: void_checks
      return _services.customDialog(context,'Description','Please enter your description');
    }
    else{
        
               await Provider.of<ClaimManagementProvider>(context,listen: false).PostClaimManagementdata(context: context,subject: _subjectcontroller.text,description: _descriptioncontroller.text,productId: widget.id).then((value){
                 Navigator.push(context,MaterialPageRoute(builder:(context)=> ClaimScreen()));
                //  Provider.of<ClaimManagementProvider>(context,listen: false).GetClaimManagementData(context: context, productid:widget.id);
                //   Navigator.push(context,MaterialPageRoute(builder:(context)=>ClaimScreen()));
               });
       
      

        // _formKey.currentState.save()
         }
     
    
  }
  @override
  Widget build(BuildContext context) {
   final claim=Provider.of<ClaimManagementProvider>(context,listen: false);
    final claimData = Provider.of<ClaimManagementProvider>(context);
     final order = Provider.of<OrderProvider>(context,listen: false);

    Size size = MediaQuery.of(context).size;
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
          title: const Text('Claim'),
        ),
        
         body: Container(
        padding:const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
           
            const Divider(color: CustomColor.orangecolor,thickness: 1),
             SizedBox(height: size.height*0.02,),
            
           
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Subject',style: Theme.of(context).textTheme.subtitle2,),
                SizedBox(
                  height: size.height*0.05,
                  child: TextFormField(
                    controller: _subjectcontroller,
                    onChanged: ((value) {
                      _subjectcontroller.text;
                    }),
      //             validator: (value) {
      //             if (value.isEmpty) {
      //             return _services.customDialog(context, 'Subject',
      //             'Please enter your claim subject');
      //   }
      //   return null;
      // },
                    
                    decoration:const InputDecoration(
                
                      border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(10)),borderSide: BorderSide(color: CustomColor.orangecolor))
                    ),
                    
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height*0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Description',style: Theme.of(context).textTheme.subtitle2,),
                TextFormField(
                  
                  controller: _descriptioncontroller,
                  onChanged: ((value) {
                    _descriptioncontroller.text;
                  }),
          //           validator: (value) {
          //         if (value.isEmpty) {
          //         return _services.customDialog(context, 'Description',
          //         'Please enter your claim description');
          //      }
          //   return null;
          // },
                  decoration:const InputDecoration(
                    
                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(10),),borderSide: BorderSide(color: CustomColor.orangecolor))
                    
                  ),
                  
                ),
              ],
            ),
             SizedBox(height: size.height*0.04,),
            
   
          
                const Divider(color: CustomColor.orangecolor,thickness: 1),
                  SizedBox(height: size.height*0.04,),
            SizedBox(
              width: size.width*0.3,
              child: ElevatedButton( 
                
                
                child:isloading?Center(child: CircularProgressIndicator(color: CustomColor.whitecolor),):
                Text('Save'),onPressed: (()async {
                  print('svsvsvsvsvsv');
                onsubmit();

              
             

             
               
                
               //Navigator.of(context).pop();
                
              }),),
            )

        
            
          ]
        )
         )
      
    );
  }
}