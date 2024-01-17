import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Pages/Property/ImageSlider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Other/FetchAdminContactWidget.dart';
import 'package:real_state/Widgets/Other/RatingDisplayWidgetTwo.dart';
import 'package:real_state/config/ApiLinks.dart';
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
    final res = await StaticMethod.changeVisitStatus(data,url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: const TextStyle(color: Colors.green),)));
        appState.activeWidget = "CustomerVisitRequestListWidget";
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: const TextStyle(color: Colors.red),)));
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
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
    } else {
      requestStatus = "Visit Completed";
      statusColor = Colors.red;
    }
    return SingleChildScrollView(
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
                    Expanded(child: Container(
                      child: Text(
                        '${appState.selectedCustomerRequest['p_name'].toUpperCase()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                        softWrap: true,
                      ),
                    ),),
                    const SizedBox(width: 10,),

                    //================================RATINGS
                    RatingDisplayWidgetTwo(rating: appState.selectedCustomerRequest['p_rating'].toDouble()),
                    //================================RATING USER COUNT
                    Text(
                        '(${appState.selectedCustomerRequest['p_ratingCount']})'
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
                      '${appState.selectedCustomerRequest['p_price']} ₹',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).hintColor
                      ),
                    ),

                    const Spacer(),
                    //=============================MEASLE NO.
                    Text(
                      'Measle No: ${appState.selectedCustomerRequest['p_un']}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).hintColor
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
                    Icon(Icons.location_on_outlined, color: Theme.of(context).hintColor,),
                    Expanded(child:  Text(
                        '${appState.selectedCustomerRequest['p_address']}, ${appState.selectedCustomerRequest['p_locality']} , ${appState.selectedCustomerRequest['p_city']}',
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
                      StaticMethod.openMap(appState.selectedProperty['p_locationurl']);
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
                  subtitle: Text('${appState.selectedCustomerRequest['c_name']}'),
                )
              ),
              //==================================CUSTOMER MOBILE
              Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                  child: ListTile(
                    title: const Text('Mobile'),
                    subtitle: Text('${appState.selectedCustomerRequest['c_mobile']}'),
                  )
              ),
              //==================================CUSTOMER EMAIL
              Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                  child: ListTile(
                    title: const Text('Email'),
                    subtitle: Text('${appState.selectedCustomerRequest['c_email']}'),
                  )
              ),
              //==================================CUSTOMER ADDRESS
              Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                  child: ListTile(
                    title: const Text('Address'),
                    subtitle: Text('${appState.selectedCustomerRequest['c_address']}, ${appState.selectedCustomerRequest['c_locality']}, ${appState.selectedCustomerRequest['c_city']}, ${appState.selectedCustomerRequest['c_pincode']}'),
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
                    subtitle: Text('${appState.selectedCustomerRequest['v_date']}'),
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
              //==================================STATUS CHANGE BTN
              const SizedBox(height: 20,),
              appState.selectedCustomerRequest['v_status']==2
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
                        "c_id":appState.selectedCustomerRequest['c_id'],
                        "p_id":appState.selectedCustomerRequest['p_id'],
                      };
                      _changeVisitStatus(data, appState, context);
                    },
                    child: Text(
                      reqBtnText,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor
                      ),
                    )
                ),
              )

      ]
        ));
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
