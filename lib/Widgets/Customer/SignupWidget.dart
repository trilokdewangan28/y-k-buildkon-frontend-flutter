import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/StaticMethod.dart';
class SignupWidget extends StatefulWidget {
  const SignupWidget({Key? key}) : super(key: key);

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _localityController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _localityFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _pincodeFocusNode = FocusNode();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text = '${selectedDate.toLocal()}'.split(' ')[0];
      });
    }
  }
  _submitData(appState, context)async{
     var customerData = {
       "c_name":_nameController.text,
       "c_mobile":_mobileController.text,
       "c_dob":_dobController.text,
       "c_email":_emailController.text,
       "c_address":_addressController.text,
       "c_locality":_localityController.text,
       "c_city":_cityController.text,
       "c_pincode":_pincodeController.text
     };
     var url = Uri.parse(ApiLinks.customerSignup);
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (dialogContext) => const Center(
         child: CircularProgressIndicator(),
       ),
     );
     final res = await StaticMethod.userSignup(customerData, url);
     if(res.isNotEmpty){
       Navigator.pop(context);
       if(res['success']==true){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.green),)));
         appState.activeWidget='LoginWidget';
       }else{
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: TextStyle(color: Colors.red),)));
       }
     }

  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: 250),
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 150,
              color: Theme.of(context).hintColor,
            ),
            Container(
              width: double.infinity,
              child: Center(
                  child:Text(
                    'Welcome To Y&K Buildkon',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  )
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //==============================SIGNUP HEADING
            Container(
              width: double.infinity,
              child:const Center(
                  child:Text(
                    'Personal Information',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25
                    ),
                  )
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //==============================FORM CONTAINER
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //=============================FULL NAME TEXTFIELD
                      Container(
                        child:TextFormField(
                            focusNode: _nameFocusNode,
                            controller: _nameController,
                            decoration:  InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    // color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter valid locality';
                              }
                              return null;
                            }
                        ),
                      ),
                      const SizedBox(height: 15,),

                      //========================MOBILE TEXTFIELD
                      Container(
                        child:TextFormField(
                            focusNode: _mobileFocusNode,
                            controller: _mobileController,
                            keyboardType: TextInputType.number,
                            decoration:  InputDecoration(
                                labelText: 'Mobile Number',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    // color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter valid locality';
                              }
                              return null;
                            }
                        ),
                      ),
                      const SizedBox(height: 15,),


                      //========================DOB TEXTFIELD
                      Container(
                        child:TextFormField(
                            focusNode: _dobFocusNode,
                            controller: _dobController,
                            keyboardType: TextInputType.number,
                            decoration:  InputDecoration(
                                labelText: 'Date Of Birth',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    // color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                )
                            ),
                            onTap: () => _selectDate(context),
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter valid locality';
                              }
                              return null;
                            }

                        ),
                      ),
                      const SizedBox(height: 15,),

                      //============================EMAIL TEXTFIELD
                      Container(
                        child:TextFormField(
                          focusNode: _emailFocusNode,
                          controller: _emailController,
                          decoration:  InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  // color: Theme.of(context).hintColor
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10),),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10),),
                              )
                          ),
                          validator: (value){
                            if(value!.isEmpty || !value.contains("@gmail.com")){
                              return "please enter valid email";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 15,),

                      //============================ADDRESS TEXTFIELD
                      Container(
                        child:TextFormField(
                            focusNode: _addressFocusNode,
                            controller: _addressController,
                            decoration:  InputDecoration(
                                labelText: 'Address',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    // color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter valid address';
                              }
                              return null;
                            }
                        ),
                      ),
                      const SizedBox(height: 15,),

                      //===============================LOCALITY AND CITY
                      Row(
                        children: [
                          Expanded(child:Container(
                            child:TextFormField(
                                focusNode: _localityFocusNode,
                                controller: _localityController,
                                decoration:  InputDecoration(
                                    labelText: 'Locality',
                                    labelStyle: TextStyle(color: Colors.black),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        // color: Theme.of(context).hintColor
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10),),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10),),
                                    )
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid locality';
                                  }
                                  return null;
                                }
                            ),
                          ),),
                          SizedBox(width: 10,),
                          Expanded(child:Container(
                            child:TextFormField(
                                focusNode: _cityFocusNode,
                                controller: _cityController,
                                decoration:  InputDecoration(
                                    labelText: 'City',
                                    labelStyle: TextStyle(color: Colors.black),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        // color: Theme.of(context).hintColor
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10),),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10),),
                                    )
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid city name';
                                  }
                                  return null;
                                }
                            ),
                          ),),
                        ],
                      ),
                      const SizedBox(height: 15,),

                      //===========================PINCODE TEXTFIELD
                      Container(
                        child:TextFormField(
                            focusNode: _pincodeFocusNode,
                            controller: _pincodeController,
                            keyboardType: TextInputType.number,
                            decoration:  InputDecoration(
                                labelText: 'Pincode',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    // color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                )
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value.length!=6) {
                                return 'please enter valid pincode';
                              }
                              return null;
                            }
                        ),
                      ),
                      const SizedBox(height: 15,),

                      //===============================SIGNUP BTN
                      ElevatedButton(
                          onPressed: (){
                            if (_formKey.currentState!.validate()) {
                              _submitData(appState, context);
                            }
                          },
                          child: Text('Signup',style: TextStyle(color: Theme.of(context).hintColor),)
                      ),
                      const SizedBox(height: 15,),

                      //================================LOGIN BTN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              'already have an account?'
                          ),
                          TextButton(
                              onPressed: (){
                                appState.activeWidget="LoginWidget";
                              },
                              child:  Text(
                                'login',
                                style: TextStyle(
                                    fontSize: 16,
                                  color: Theme.of(context).hintColor
                                ),
                              )
                          )
                        ],
                      )

                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
