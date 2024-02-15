import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
class OtpVerificationWidgetForEmployee extends StatefulWidget {
  Map<String,dynamic> employeeData;
  OtpVerificationWidgetForEmployee({super.key, required this.employeeData});

  @override
  State<OtpVerificationWidgetForEmployee> createState() => _OtpVerificationWidgetForEmployeeState();
}

class _OtpVerificationWidgetForEmployeeState extends State<OtpVerificationWidgetForEmployee> {
  bool _mounted = false;
  @override
  void initState() {
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('otp sent to your email...',style: TextStyle(color: Colors.green),)));
    _mounted=true;
    startCountdown();
    super.initState();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  final _formKey1 = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();


  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Colors.black,
    ),
    decoration: BoxDecoration(
      color: const Color.fromARGB(150, 255, 255, 255),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color.fromARGB(255, 18, 19, 19),width: 1),
    ),
  );


  //----------------------------------------------------------------------------COUNTDOWN VARIABLE
  bool otpSent = false;
  Duration countdownDuration = const Duration(minutes: 5); // Example: 10 minutes
  Timer? countdownTimer;
  String remainingTime = '';
  //----------------------------------------------------------------------------COUNTDOWN METHODS
  void startCountdown() {
    _mounted = true;

    if (countdownTimer == null || !countdownTimer!.isActive) {
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if(_mounted){
          setState(() {
            if (countdownDuration.inSeconds > 0) {
              countdownDuration -= const Duration(seconds: 1);
              remainingTime = formatDuration(countdownDuration);
            } else {
              countdownTimer?.cancel();
              // Countdown has reached 0, perform any desired actions here
            }
          });
        }
      });
    }

  }
  String formatDuration(Duration duration) {
    String minutes =
    duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  _sendOtpForEmployeeSignup(employeeData,appState, context) async {
    var url = Uri.parse(ApiLinks.sendOtpForEmployeeSignup);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.sendOtpForSignup(employeeData, url);
    //print(res);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        countdownTimer?.cancel();
        countdownDuration = const Duration(minutes: 5);
        remainingTime = formatDuration(countdownDuration);
        _mounted=true;
        startCountdown();
        Fluttertoast.showToast(
          msg: '${res['message']} ${res['error']}',
          toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
          gravity: ToastGravity.TOP, // Toast position
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.green, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
      } else {
        Fluttertoast.showToast(
          msg: '${res['message']} ${res['error']}',
          toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
          gravity: ToastGravity.TOP, // Toast position
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.red, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
      }
    }
  }

  _verifyOtpForSignup(employeeData,appState, context) async {

    var url = Uri.parse(ApiLinks.verifyOtpForEmployeeSignup);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.verifyOtpForSignup(employeeData, url);
    if (res.isNotEmpty) {
      //print(res);
      Navigator.pop(context);
      if (res['success'] == true) {
        Fluttertoast.showToast(
          msg: '${res['message']} ${res['error']}',
          toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
          gravity: ToastGravity.TOP, // Toast position
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.green, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
        appState.activeWidget = "LoginWidget";
        appState.currentState = 1;
        Navigator.pop(context);
      } else {
        //print(res['error']);
        Fluttertoast.showToast(
          msg: '${res['message']} ${res['error']}',
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
    return PopScope(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Email Verificaiton',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MyConst.deviceHeight(context)*0.1,),
                const Text(
                  'verification code has been sent to : ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  '${widget.employeeData['email']}',
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                  ),
                ),
                SizedBox(height: MyConst.deviceHeight(context)*0.1,),
                //==============================FORM2 CONTAINER Login
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey1,
                      child: Column(
                        children: [
                          const Text(
                            'Enter otp here',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16
                            ),
                          ),
                          const SizedBox(height: 20,),
                          //==================================OTP TEXTFIELD
                          Pinput(
                            controller: _otpController,
                            focusNode: _otpFocusNode,
                            length: 6,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                border: Border.all(color: Theme.of(context).primaryColorLight),
                              ),
                            ),
                            validator: (value){
                              if(value!.isEmpty || value.length!=6){
                                return "please enter correct otp";
                              }
                              return null;
                            },
                            onCompleted: (pin) => debugPrint(pin),
                          ),

                          //=================COUNTDOWN AND RESEND CONTAINER
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                //=================================COUNTDOWN TEXT
                                Text(
                                  remainingTime,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const Spacer(),

                                //==========================RESENT OTP BUTTON
                                TextButton(
                                  onPressed: (){
                                    var employeeData = {
                                      "email":widget.employeeData['email']
                                    };
                                    _sendOtpForEmployeeSignup(employeeData, appState, context);
                                  },
                                  child: Text('resend otp',style: TextStyle(color: Theme.of(context).primaryColor),),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 15,),


                          //===============================LOGIN BTN
                          Container(
                            width: 150,
                            child: ElevatedButton(
                                onPressed: (){
                                  if (_formKey1.currentState!.validate()) {
                                    var employeeData = {
                                      "name": widget.employeeData['name'],
                                      "mobile": widget.employeeData['mobile'],
                                      "email": widget.employeeData['email'],
                                      "dob": widget.employeeData['dob'],
                                      "blood_group": widget.employeeData['blood_group'],
                                      "education":widget.employeeData['education'],
                                      "profession":widget.employeeData['profession'],
                                      "interest":widget.employeeData['interest'],
                                      "fname":widget.employeeData['fname'],
                                      "mname":widget.employeeData['mname'],
                                      "address":widget.employeeData['address'],
                                      "city":widget.employeeData['city'],
                                      "state": widget.employeeData['state'],
                                      "pincode": widget.employeeData['pincode'],
                                      "nominee_name":widget.employeeData['nominee_name'],
                                      "nominee_dob":widget.employeeData['nominee_dob'],
                                      "relation":widget.employeeData['relation'],
                                      "referal_code":widget.employeeData['referal_code'],
                                      "otp":_otpController.text
                                    };
                                    _verifyOtpForSignup(employeeData, appState, context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                ),
                                child: Text('Verify',style: TextStyle(color: Theme.of(context).primaryColorLight),)
                            ),
                          ),
                          const SizedBox(height: 15,),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
}
