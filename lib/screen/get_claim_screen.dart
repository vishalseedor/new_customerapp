import 'package:flutter/material.dart';
import 'package:food_app/const/color_const.dart';
import 'package:food_app/models/claim.dart';
import 'package:food_app/provider/claim_management_provider.dart';
import 'package:provider/provider.dart';

import '../widget/custom_painter.dart';
import '../widget/dot.dart';
class GetClaimManagementScreen extends StatefulWidget {
  final String id;
  const GetClaimManagementScreen({Key key,@required this.id}) : super(key: key);
    static const routeName = 'getclaim-screen';

  @override
  State<GetClaimManagementScreen> createState() => _GetClaimManagementScreenState();
}

class _GetClaimManagementScreenState extends State<GetClaimManagementScreen> {

@override
void initState(){
 super.initState();

 
}
  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
 //final claimData = Provider.of<ClaimModel>(context);
 final claim=Provider.of<ClaimManagementProvider>(context,listen: false);
 
 final claimDetails =
        Provider.of<ClaimManagementProvider>(context).claim.firstWhere((element) => element.id == widget.id);

  
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
      
      title:const Text('Claim Details'),),
    body: Column(
      children: [
        Divider(thickness: 1,color: CustomColor.orangecolor,),
        Container(
          margin: const EdgeInsets.all(23),
              height: size.height*0.5,
              width: size.width*0.9,
              decoration:BoxDecoration(
                color: CustomColor.grey100,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                         
                          border: Border.all(
                            color: CustomColor.orangecolor,
                            width: 1,
                          )),
          child: Column(
            children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                   Text('Subject',    style: Theme.of(context).textTheme.headline4),
                   Text('Type',style: Theme.of(context).textTheme.headline4)
                  ],
                 ),
               ),
               VerticalDivider(color: CustomColor.blackcolor,thickness: 1,),
                   

                 Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text(claimDetails.subject, style: Theme.of(context).textTheme.headline4 ),
                 Text(claimDetails.claimType,  style: Theme.of(context).textTheme.headline4 )
                ],
               ),
                    ],
                  ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(20),
              //       child: Column(

              //         children: [
              //           Text('Subject',  style: TextStyle(fontSize: 15),),
              //           Text('Type',style: TextStyle(fontSize: 15)),
              //         ],
              //       ),
              //     ),
              //     Column(

              //       children: [
              //         Text(claim.claimModel.subject,  style: TextStyle(fontSize: 15),),
              //         Text(claim.claimModel.claimType,style: TextStyle(fontSize: 15)),
              //       ],
              //     ),
              //   ],
              // ),
                 
                  
                   const DotDivider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
               Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                 Text('Date',   style: Theme.of(context).textTheme.headline4 ),
                 Text(claimDetails.date.substring(0,10), style: Theme.of(context).textTheme.headline4 )
                ],
               ),
           

                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                 Text('Deadline',   style: Theme.of(context).textTheme.headline4 ),
                 Text(claimDetails.deadlineDate, style: Theme.of(context).textTheme.headline4)
                ],
               ),
                    ],
                  ),
                  
                  SizedBox(height: size.height*0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
               Text('Model Reference',  style: Theme.of(context).textTheme.headline4),
                 VerticalDivider(thickness: 1,color: CustomColor.blackcolor,),
               Text(claimDetails.modelrefer.substring(16),  style: Theme.of(context).textTheme.headline4  )
                    ],
                  ),
              SizedBox(height: size.height*0.03),

                   Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               
               children: [
                 Text('Description', style: Theme.of(context).textTheme.headline4,),
                 Container(
                   height: size.height*0.1,
                   width: size.width*0.8 ,
                     decoration:BoxDecoration(
                color: CustomColor.whitecolor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                
                  
                  ),
                  child: Center(child: Text(claimDetails.description,style: Theme.of(context).textTheme.headline4)),
                
                 )
                 
               ],
                    ),
        
            ],
          ),
        ),
       
        Container(
           height: size.height*0.3,
              width: size.width*0.9,
               decoration: const BoxDecoration(
                  color: CustomColor.grey100,
     
              borderRadius: BorderRadius.all(Radius.circular(20)),
        
               ),

               child: Column(
               
                 children: [
                  Container(
                    height: size.height*0.2,
                    child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                   // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Priority', style: Theme.of(context).textTheme.headline4  ),
                //  Text(claimDetails.priority,style: Theme.of(context).textTheme.headline4)
                      Row(
                        children: [
                          Icon(Icons.star,color: CustomColor.yellowcolor,),
                          SizedBox(width: size.width*0.01,),
                           Icon(Icons.star,color: CustomColor.yellowcolor,),

                        ],
                      )
                    ],
                   ),
                      SizedBox(height: size.height*0.03,),
                         Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: Text('Resolution',    style: Theme.of(context).textTheme.headline4),
                      ),
                       Text(claimDetails.resolution,   style: Theme.of(context).textTheme.subtitle2),
                     
                    ],
                   ),

                      ],
                    ),
                  ),
                 
                
                   
                 
                   Container(
                    height: size.height*0.1,
                    width: size.width*0.9,
             
                    decoration:  BoxDecoration(
                             color: CustomColor.orangecolor,
                      borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight:Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height*0.05,
                            width: size.width*0.79,
                         
                            decoration: BoxDecoration(
                                 color: CustomColor.whitecolor,borderRadius: BorderRadius.circular(25)),
                                 child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'New',
                                  style: TextStyle(fontSize: 13)
                                      
                                     
                                ),
                              ),
                              Image.asset('Assets/Images/check1.png',height: size.height*0.02,)
                            ],
                          ),
                          SizedBox(
                            width: size.width * 0.15,
                            child: const Divider(
                              color: CustomColor.orangecolor,
                              thickness: 2,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Inprogress',
                                  style: TextStyle(fontSize: 13)
                                   
                              ),
                                Image.asset('Assets/Images/check2.png',height: size.height*0.02,)
                            ],
                          ),
                          SizedBox(
                            width: size.width * 0.15,
                            child: const Divider(
                              color: CustomColor.grey400,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Done',
                              style: TextStyle(fontSize: 13)
                                  
                              ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset('Assets/Images/check3.png',height: size.height*0.02,),
                                )
                            ],
                          ),
                        ],
                      ),
                          ),
                        ],
                      ),
                   )
                   
                 ],
               ),
               

        )
      ],
    ),
    
    
    
     
          );
          
 
   
    
  }

}