import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';

import '../../config/Constant.dart';
import '../../services/ThemeService/theme.dart';
class EditCustomerDetailPage extends StatefulWidget {
  final Map<String,dynamic> customerDetails;
  const EditCustomerDetailPage({super.key, required this.customerDetails});

  @override
  State<EditCustomerDetailPage> createState() => _EditCustomerDetailPageState();
}

class _EditCustomerDetailPageState extends State<EditCustomerDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String name='';
  String mobile='';
  String email='';
  String address='';
  String locality='';
  String city='';
  String pincode='';



  updateDetails(data, appState, context) async {
    var url = Uri.parse(ApiLinks.updateCustomerDetails);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>  Center(
        child: StaticMethod.progressIndicator()
      ),
    );
    final res = await StaticMethod.updateCustomerDetails(appState.token, url, data);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
        appState.activeWidget = "ProfileWidget";
        Navigator.pop(context);
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
        //print(res['error']);
      }
    }
  }

  @override
  void initState() {
    name = widget.customerDetails['customer_name'];
    mobile = widget.customerDetails['customer_mobile'].toString();
    email = widget.customerDetails['customer_email'];
    address = widget.customerDetails['customer_address'];
    locality = widget.customerDetails['customer_locality'];
    city = widget.customerDetails['customer_city'];
    pincode = widget.customerDetails['customer_pincode'].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context, listen: false);
    return PopScope(
        child: Scaffold(
            backgroundColor: context.theme.backgroundColor,
            appBar: _appBar('Edit Details'),
            body: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //==================================NAME TILE
                        Card(
                          color: context.theme.backgroundColor,
                          child: ListTile(
                            title: const Text(
                              'Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                                controller: TextEditingController(text: widget.customerDetails['customer_name']),
                                decoration: const InputDecoration(
                                  border: InputBorder.none, // Remove underline here
                                ),
                                onChanged: (value){
                                  name = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'name should not be empty';
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),

                        //==================================MOBILE TILE
                        Card(
                          color: context.theme.backgroundColor,
                          child: ListTile(
                            title: const Text(
                              'Mobile',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                                controller: TextEditingController(text: widget.customerDetails['customer_mobile'].toString()),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none, // Remove underline here
                                ),
                                onChanged: (value){
                                  mobile = value.toString();
                                },
                                validator: (value) {
                                  if (value!.length!=10) {
                                    return 'please enter valid mobile number';
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),

                        //==================================EMAIL TILE
                        Card(
                          color: context.theme.backgroundColor,
                          child: ListTile(
                            title: const Text(
                              'Email',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_email']),
                              decoration: const InputDecoration(
                                border: InputBorder.none, // Remove underline here
                              ),
                              onChanged: (value){
                                email = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty || !value.contains("@gmail.com")) {
                                  return "please enter valid email";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        //==================================ADDRESS TILE
                        Card(
                          color: context.theme.backgroundColor,
                          child: ListTile(
                            title: const Text(
                              'Address',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_address']),
                              decoration: const InputDecoration(
                                border: InputBorder.none, // Remove underline here
                              ),
                              onChanged: (value){
                                address = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "please enter valid address";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        //==================================LOCALITY TILE
                        Card(
                          color: context.theme.backgroundColor,
                          child: ListTile(
                            title: const Text(
                              'Locality',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_locality']),
                              decoration: const InputDecoration(
                                border: InputBorder.none, // Remove underline here
                              ),
                              onChanged: (value){
                                locality = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "please enter valid locality";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        //==================================CITY TILE
                        Card(
                          color: context.theme.backgroundColor,
                          child: ListTile(
                            title: const Text(
                              'City',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_city']),
                              decoration: const InputDecoration(
                                border: InputBorder.none, // Remove underline here
                              ),
                              onChanged: (value){
                                city = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "please enter valid city";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        //==================================PINCODE TILE
                        Card(
                          color: context.theme.backgroundColor,
                          child: ListTile(
                            title: const Text(
                              'Pincode',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_pincode'].toString()),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none, // Remove underline here
                              ),
                              onChanged: (value){
                                name = value.toString();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "please enter valid pincode";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bluishClr,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            onPressed: (){
                              if (_formKey.currentState!.validate()) {
                                var data={
                                  "c_name":name,
                                  "c_mobile":mobile,
                                  "c_email":email,
                                  "c_address":address,
                                  "c_locality":locality,
                                  "c_city":city,
                                  "c_pincode":pincode,
                                  "c_id":widget.customerDetails['customer_id']
                                };
                                updateDetails(data, appState, context);
                              }
                            },
                            child: Text(
                              'SUBMIT',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontWeight: FontWeight.w500
                              ),
                            )
                        )

                      ],
                    ),
                  ),
                )
            )
        )
    );
  }
  _appBar(appBarContent){
    return AppBar(
      foregroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color:Get.isDarkMode ?  Colors.white70 :Colors.black,
        size: MyConst.deviceHeight(context)*0.030,
      ),
      toolbarHeight: MyConst.deviceHeight(context)*0.060,
      titleSpacing: MyConst.deviceHeight(context)*0.02,
      elevation: 0.0,
      title:Text(
        appBarContent,
        style: appbartitlestyle,
        softWrap: true,
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(
                'assets/images/ic_launcher.png'
            ),
          ),
        )
      ],
      backgroundColor: context.theme.backgroundColor,
    );
  }
}
