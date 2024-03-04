import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Customer/OtpVerificationWidget.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';

import '../../services/ThemeService/theme.dart';

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
        StaticMethod.showDialogBar(res['message'], Colors.green);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpVerificationWidget(
                      customerData: customerData,
                    )));
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor =
        MyConst.deviceWidth(context) / MyConst.referenceWidth;
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          appState.activeWidget = 'LoginWidget';
        },
        child: Container(
          color: Theme.of(context).primaryColorLight,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 250),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  //==============================SIGNUP HEADING
                  Container(
                    width: double.infinity,
                    child: const Center(
                        child: Text(
                      'Personal Information',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
                            _textField(
                                controller: _nameController,
                                focusNode: _nameFocusNode,
                                label: 'Full Name',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid name';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text),

                            const SizedBox(
                              height: 15,
                            ),

                            //=============================MOBILE TEXTFIELD
                            _textField(
                                controller: _mobileController,
                                focusNode: _mobileFocusNode,
                                label: 'Mobile Number',
                                validator: (value) {
                                  if (value!.isEmpty || value.length != 10) {
                                    return 'please enter valid number';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.number),

                            const SizedBox(
                              height: 15,
                            ),

                            //============================EMAIL TEXTFIELD
                            _textField(
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                label: "Email",
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !value.contains("@gmail.com")) {
                                    return "please enter valid email";
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text),

                            const SizedBox(
                              height: 15,
                            ),

                            //============================ADDRESS TEXTFIELD
                            _textField(
                                controller: _addressController, 
                                focusNode: _addressFocusNode, 
                                label: "Address", 
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "please enter valid address";
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            //===============================LOCALITY AND CITY
                            Row(
                              children: [
                                Expanded(
                                  child: _textField(
                                      controller: _localityController, 
                                      focusNode: _localityFocusNode, 
                                      label: "Locality", 
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter valid locality";
                                        }
                                        return null;
                                      }, 
                                      inputType: TextInputType.text
                                  )
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: _textField(
                                      controller: _cityController,
                                      focusNode: _cityFocusNode,
                                      label: "City",
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "please enter valid city";
                                        }
                                        return null;
                                      },
                                      inputType: TextInputType.text
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            //===========================PINCODE TEXTFIELD
                            _textField(
                                controller: _pincodeController,
                                focusNode: _pincodeFocusNode,
                                label: "Pincode",
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "please enter valid pincode";
                                  }
                                  return null;
                                },
                                inputType: TextInputType.number
                            ),

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
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
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
                                          color:
                                              Theme.of(context).primaryColor),
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
        ));
  }

  _textField(
      {required TextEditingController? controller,
      required FocusNode? focusNode,
      required String? label,
      required validator,
      required TextInputType? inputType}) {
    return TextFormField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: primaryColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: context.theme.primaryColorDark,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        validator: validator);
  }
}
