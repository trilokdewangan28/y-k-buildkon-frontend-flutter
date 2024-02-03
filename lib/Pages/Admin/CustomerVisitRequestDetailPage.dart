import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Other/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';

class CustomerVisitRequestDetailPage extends StatefulWidget {
  const CustomerVisitRequestDetailPage({Key? key}) : super(key: key);

  @override
  State<CustomerVisitRequestDetailPage> createState() => _CustomerVisitRequestDetailPageState();
}

class _CustomerVisitRequestDetailPageState extends State<CustomerVisitRequestDetailPage> {
  String requestStatus = "";
  Color statusColor = Colors.orange;
  String reqBtnText = "";
  Color reqBtnColor = Colors.green;
  int newStatus = 0;

  DateTime selectedDate =  DateTime.now().add(const Duration(days: 1));
  final DateTime lastSelectableDate = DateTime.now().add(const Duration(days: 365));
  final DateTime firstSelectableDate = DateTime.now().add(const Duration(days: 1));

  _changeVisitStatus(data,appState,context)async{
    var url = Uri.parse(ApiLinks.changeVisitStatus);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.changeVisitStatus(appState.token,data,url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
          gravity: ToastGravity.TOP, // Toast position
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.green, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
        appState.activeWidget = "CustomerVisitRequestListWidget";
      }else{
        Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
          gravity: ToastGravity.TOP, // Toast position
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.red, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    if (appState.selectedCustomerRequest['v_status'] == 0) {
      requestStatus = "New Request";
      statusColor = Colors.orange;
      reqBtnText = "Accept Visit Request";
      reqBtnColor = Colors.green;
    } else if (appState.selectedCustomerRequest['v_status'] == 1) {
      requestStatus = "Request Accepted";
      statusColor = Colors.green;
      reqBtnText = "Mark Complete The Visit";
      reqBtnColor = Colors.red;
    } else if(appState.selectedCustomerRequest['v_status'] == 2){
      requestStatus = "Visit Completed";
      statusColor = Colors.red;
    }else{
      requestStatus = "request cancelled";
      statusColor = Colors.red;
    }
    return Container(
      color: Theme.of(context).primaryColorLight,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //===========================PROPERTY IMAGES
                /*
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Stack(
                    children: [
                      ClipRRect(

                          child: appState.selectedCustomerRequest['pi_name'].length != 0
                              ? Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(color: Colors.white),
                            child: ImageSlider(
                              propertyData: appState.selectedProperty,
                              asFinder: true,
                            ),
                          )
                              : Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(25)),
                            child: const Center(child: Text('no image found')),
                          )
                      ),
                    ],
                  )
              ),

               */
                //=======================HEADING 1================================
                const SizedBox(height: 20,),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                    child: const Center(
                      child: Text(
                        'PROPERTY DETAILS',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18
                        ),
                      ),
                    )
                ),
                const Divider(),



                //===========================PROPERTY DETAIL SECTION
                //================================== ROW 1
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                  child: Row(
                    children: [
                      //================================NAME
                      Expanded(
                        child:  Text(
                          '${appState.selectedCustomerRequest['property_name'].toUpperCase()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                          softWrap: true,
                        ),),
                      const SizedBox(width: 10,),

                      //================================RATINGS
                      RatingDisplayWidgetTwo(rating: appState.selectedCustomerRequest['property_rating'].toDouble()),
                      //================================RATING USER COUNT
                      Text(
                          '(${appState.selectedCustomerRequest['property_ratingCount']})'
                      )

                    ],
                  ),
                ),

                //==================================ROW 2
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                  child: Row(
                    children: [
                      //=============================PRICE
                      Text(
                        '${appState.selectedCustomerRequest['property_price']} ₹',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor
                        ),
                      ),

                      const Spacer(),
                      //=============================MEASLE NO.
                      Text(
                        'Measle No: ${appState.selectedCustomerRequest['property_un']}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                    ],
                  ),
                ),     //-----------price
                // SizedBox(height: 10,),


                //==================================ROW 3
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                  child: Row(
                    children: [
                      //============================LOCATION
                      Icon(Icons.location_on_outlined, color: Theme.of(context).primaryColor,),
                      Expanded(child:  Text(
                        '${appState.selectedCustomerRequest['property_address']}, ${appState.selectedCustomerRequest['property_locality']} , ${appState.selectedCustomerRequest['property_city']}',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                        ),
                        softWrap: true,
                      ),

                      )
                    ],
                  ),
                ),



                //==========================================LOCATION MAP
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15, top: 15),
                  child: const Text(
                    'Location',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, ),
                    child: InkWell(
                      highlightColor: Theme.of(context).primaryColorDark,
                      onTap: () {
                        //print('map url is ${appState.selectedProperty['p_locationurl']}');
                        StaticMethod.openMap(appState.selectedProperty['property_locationurl']);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          'assets/images/map.jpg',
                          fit: BoxFit.cover,
                          height: 100,
                          width: double.infinity,
                        ),
                      ),
                    )),

                const Divider(),

                //======================CUSTOMER DETAIL SECTION===================
                const SizedBox(height: 20,),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                    child: const Center(
                      child: Text(
                        'CUSTOMER DETAILS',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18
                        ),
                      ),
                    )
                ),
                const Divider(),

                //==================================CUSTOMER NAME
                Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                    child: ListTile(
                      title: const Text('Name'),
                      subtitle: Text('${appState.selectedCustomerRequest['customer_name']}'),
                    )
                ),
                //==================================CUSTOMER MOBILE
                Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                    child: ListTile(
                      title: const Text('Mobile'),
                      subtitle: Text('${appState.selectedCustomerRequest['customer_mobile']}'),
                    )
                ),
                //==================================CUSTOMER EMAIL
                Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                    child: ListTile(
                      title: const Text('Email'),
                      subtitle: Text('${appState.selectedCustomerRequest['customer_email']}'),
                    )
                ),
                //==================================CUSTOMER ADDRESS
                Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                    child: ListTile(
                      title: const Text('Address'),
                      subtitle: Text('${appState.selectedCustomerRequest['customer_address']}, ${appState.selectedCustomerRequest['customer_locality']}, ${appState.selectedCustomerRequest['customer_city']}, ${appState.selectedCustomerRequest['customer_pincode']}'),
                    )
                ),
                //==================================VISITOR NAME
                Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                    child: ListTile(
                      title: const Text('Visitor Name'),
                      subtitle: Text('${appState.selectedCustomerRequest['visitor_name']}'),
                    )
                ),
                //==================================VISITOR NUMBER
                Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                    child: ListTile(
                      title: const Text('Visitor Number'),
                      subtitle: Text('${appState.selectedCustomerRequest['visitor_number']}'),
                    )
                ),
                //==================================VISITING DATE
                Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                    child: ListTile(
                      title: const Text('Visiting Date'),
                      subtitle: Text('${appState.selectedCustomerRequest['visiting_date']}'),
                    )
                ),
                //==================================VISITING Status
                Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                    child: ListTile(
                      title: const Text('Visiting Status'),
                      subtitle: Text(requestStatus, style: TextStyle(color: statusColor),),
                    )
                ),
                const SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //==================================STATUS CHANGE BTN
                      appState.selectedCustomerRequest['v_status']>=2
                          ? Container()
                          : Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: reqBtnColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                            onPressed: () {
                              if(appState.selectedCustomerRequest['v_status']==0){
                                newStatus=1;
                              }else if(appState.selectedCustomerRequest['v_status']==1){
                                newStatus=2;
                              }else{
                                newStatus=2;
                              }
                              var data = {
                                "newStatus":newStatus,
                                "c_id":appState.selectedCustomerRequest['customer_id'],
                                "p_id":appState.selectedCustomerRequest['property_id'],
                                "v_id":appState.selectedCustomerRequest['v_id']
                              };
                              _changeVisitStatus(data, appState, context);
                            },
                            child: Text(
                              reqBtnText,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight
                              ),
                            )
                        ),
                      ),
                      const SizedBox(width: 10,),
                      appState.selectedCustomerRequest['v_status']==0
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).errorColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                          onPressed:(){
                             newStatus=3;
                            var data = {
                              "newStatus":newStatus,
                              "c_id":appState.selectedCustomerRequest['customer_id'],
                              "p_id":appState.selectedCustomerRequest['property_id'],
                              "v_id":appState.selectedCustomerRequest['v_id']
                            };
                            _changeVisitStatus(data, appState, context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColorLight
                            ),
                          )
                      )
                          : Container()
                    ],
                  ),
                )

              ]
          )),
    );
  }
}
//
// class StatusDropdown extends StatefulWidget {
//   String requestStatus;
//   StatusDropdown({Key? key, required this.requestStatus}) : super(key: key);
//   @override
//   _StatusDropdownState createState() => _StatusDropdownState();
// }
//
// class _StatusDropdownState extends State<StatusDropdown> {
//   int onSelectedValue = 0;
//   String selectedValue = "";
//
//   @override
//   Widget build(BuildContext context) {
//     selectedValue=widget.requestStatus;
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Text('Selected Value: ${selectedValue}'),
//         SizedBox(height: 20),
//         DropdownButton<String>(
//           value: selectedValue,
//           onChanged: (String? newValue) {
//             setState(() {
//               if(newValue == "Accept"){
//                 onSelectedValue = 1;
//               }else if(newValue == "Complete"){
//                 onSelectedValue=2;
//               }else{
//                 onSelectedValue=0;
//               }
//             });
//           },
//           items: <String>['Pending', 'Accept', 'Complete']
//               .map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
