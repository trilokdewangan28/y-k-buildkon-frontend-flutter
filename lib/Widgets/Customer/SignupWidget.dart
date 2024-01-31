import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Customer/OtpVerificationWidget.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
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
  //final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _localityController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  //final FocusNode _dobFocusNode = FocusNode();
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
        //_dobController.text = '${selectedDate.toLocal()}'.split(' ')[0];
      });
    }
  }

  _sendOtpForSignup(appState, context) async {
    var customerData = {
      "c_name": _nameController.text,
      "c_mobile": _mobileController.text,
      "c_email": _emailController.text,
      "c_address": _addressController.text,
      "c_locality": _localityController.text,
      "c_city": _cityController.text,
      "c_pincode": _pincodeController.text
    };
    var url = Uri.parse(ApiLinks.sendOtpForSignup);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.sendOtpForSignup(customerData, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
          gravity: ToastGravity.TOP, // Toast position
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.green, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerificationWidget(customerData: customerData,)));
      } else {
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
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 250),
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                color: Theme.of(context).hintColor,
              ),
              Container(
                width: double.infinity,
                child: const Center(
                    child: Text(
                      'Welcome To Y&K Buildkon',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              //==============================SIGNUP HEADING
              Container(
                width: double.infinity,
                child: const Center(
                    child: Text(
                      'Personal Information',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                    )),
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
                        TextFormField(
                            focusNode: _nameFocusNode,
                            controller: _nameController,
                            decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(10),),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.black,
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

                        const SizedBox(
                          height: 15,
                        ),

                        //========================MOBILE TEXTFIELD
                        TextFormField(
                            focusNode: _mobileFocusNode,
                            controller: _mobileController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(10),),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter valid locality';
                              }
                              return null;
                            }),

                        const SizedBox(
                          height: 15,
                        ),

                        //========================DOB TEXTFIELD
                        // TextFormField(
                        //     focusNode: _dobFocusNode,
                        //     controller: _dobController,
                        //     keyboardType: TextInputType.number,
                        //     decoration: const InputDecoration(
                        //         labelText: 'Date Of Birth',
                        //         labelStyle: TextStyle(color: Colors.black),
                        //         focusedBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 1,
                        //             // color: Theme.of(context).hintColor
                        //           ),
                        //           borderRadius: BorderRadius.all(
                        //             Radius.circular(10),
                        //           ),
                        //         ),
                        //         border: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 1,
                        //             color: Colors.grey,
                        //           ),
                        //           borderRadius: BorderRadius.all(
                        //             Radius.circular(10),
                        //           ),
                        //         )),
                        //     onTap: () => _selectDate(context),
                        //     readOnly: true,
                        //     validator: (value) {
                        //       if (value!.isEmpty) {
                        //         return 'please enter valid locality';
                        //       }
                        //       return null;
                        //     }),
                        //
                        // const SizedBox(
                        //   height: 15,
                        // ),

                        //============================EMAIL TEXTFIELD
                        TextFormField(
                          focusNode: _emailFocusNode,
                          controller: _emailController,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Theme.of(context).hintColor
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(10),),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10),),
                              )
                          ),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains("@gmail.com")) {
                              return "please enter valid email";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        //============================ADDRESS TEXTFIELD
                        TextFormField(
                            focusNode: _addressFocusNode,
                            controller: _addressController,
                            decoration: InputDecoration(
                                labelText: 'Address',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(10),),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter valid address';
                              }
                              return null;
                            }),

                        const SizedBox(
                          height: 15,
                        ),

                        //===============================LOCALITY AND CITY
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                  focusNode: _localityFocusNode,
                                  controller: _localityController,
                                  decoration: InputDecoration(
                                      labelText: 'Locality',
                                      labelStyle: TextStyle(color: Colors.black),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Theme.of(context).hintColor
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(10),),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(10),),
                                      )
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter valid locality';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                  focusNode: _cityFocusNode,
                                  controller: _cityController,
                                  decoration:  InputDecoration(
                                      labelText: 'City',
                                      labelStyle: TextStyle(color: Colors.black),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Theme.of(context).hintColor
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(10),),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(10),),
                                      )
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter valid city name';
                                    }
                                    return null;
                                  }),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        //===========================PINCODE TEXTFIELD
                        TextFormField(
                            focusNode: _pincodeFocusNode,
                            controller: _pincodeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Pincode',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(10),),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10),),
                                )
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value.length != 6) {
                                return 'please enter valid pincode';
                              }
                              return null;
                            }),

                        const SizedBox(
                          height: 20,
                        ),

                        //===============================SIGNUP BTN

                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _sendOtpForSignup(appState, context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).hintColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                            child: Text(
                              'Next',
                              style:
                              TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600),
                            )),),
                        const SizedBox(
                          height: 15,
                        ),

                        //================================LOGIN BTN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('already have an account?'),
                            TextButton(
                                onPressed: () {
                                  appState.activeWidget = "LoginWidget";
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).hintColor),
                                ))
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
