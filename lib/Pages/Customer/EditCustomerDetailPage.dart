import 'package:flutter/material.dart';
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
    print('$name, $mobile, $email, $address, $locality, $city, $pincode');
    return PopScope(
        child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                    'Edit Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),
                centerTitle: true,
                backgroundColor: Theme.of(context).primaryColorLight,
              ),
              body: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //==================================NAME TILE
                        Card(
                          child: ListTile(
                            title: Text(
                              'Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_name']),
                              decoration: InputDecoration(
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
                          child: ListTile(
                            title: Text(
                              'Mobile',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_mobile'].toString()),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
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
                          child: ListTile(
                            title: Text(
                              'Email',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_email']),
                              decoration: InputDecoration(
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
                          child: ListTile(
                            title: Text(
                              'Address',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_address']),
                              decoration: InputDecoration(
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
                          child: ListTile(
                            title: Text(
                              'Locality',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_locality']),
                              decoration: InputDecoration(
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
                          child: ListTile(
                            title: Text(
                              'City',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_city']),
                              decoration: InputDecoration(
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
                          child: ListTile(
                            title: Text(
                              'Pincode',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            subtitle: TextFormField(
                              controller: TextEditingController(text: widget.customerDetails['customer_pincode'].toString()),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
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
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            onPressed: (){
                              if (_formKey.currentState!.validate()) {
                                //_sendOtpForSignup(appState, context);
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
        )
    );
  }
}
