import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
class OtpVerificationWidget extends StatefulWidget {
  Map<String,dynamic> customerData;
   OtpVerificationWidget({super.key, required this.customerData});

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
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

  _sendOtpForSignup(customerData,appState, context) async {
    var url = Uri.parse(ApiLinks.sendOtpForSignup);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.sendOtpForSignup(customerData, url);
    //print(res);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        countdownTimer?.cancel();
        countdownDuration = const Duration(minutes: 5);
        remainingTime = formatDuration(countdownDuration);
        _mounted=true;
        startCountdown();
        StaticMethod.showDialogBar(res['message'], Colors.green);
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  _verifyOtpForSignup(customerData,appState, context) async {

    var url = Uri.parse(ApiLinks.verifyOtpForSignup);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.verifyOtpForSignup(customerData, url);
    if (res.isNotEmpty) {
      //print(res);
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
        appState.activeWidget = "LoginWidget";
        appState.currentState = 1;
        Navigator.pop(context);
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
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
                  '${widget.customerData['c_email']}',
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
                                    var customerData = {
                                      "c_email":widget.customerData['c_email']
                                    };
                                    _sendOtpForSignup(customerData, appState, context);
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
                                    var customerData = {
                                      "c_name": widget.customerData['c_name'],
                                      "c_mobile": widget.customerData['c_mobile'],
                                      "c_email": widget.customerData['c_email'],
                                      "c_address": widget.customerData['c_address'],
                                      "c_locality": widget.customerData['c_locality'],
                                      "c_city": widget.customerData['c_city'],
                                      "c_pincode": widget.customerData['c_pincode'],
                                      "c_otp":_otpController.text
                                    };
                                    _verifyOtpForSignup(customerData, appState, context);
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
