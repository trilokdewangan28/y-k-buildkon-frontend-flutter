import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
class OtpVerificationWidget extends StatefulWidget {
  const OtpVerificationWidget({super.key});

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {

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
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownDuration.inSeconds > 0) {
          countdownDuration -= const Duration(seconds: 1);
          remainingTime = formatDuration(countdownDuration);
        } else {
          countdownTimer?.cancel();
          // Countdown has reached 0, perform any desired actions here
        }
      });
    });
  }
  String formatDuration(Duration duration) {
    String minutes =
    duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Verification Page'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 100,),
                Center(
                  child: Text('we have sent an otp in your email'),
                ),
                SizedBox(height: 50,),
                //==============================FORM2 CONTAINER Login
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey1,
                      child: Column(
                        children: [
                          Text('Enter otp here'),
                          SizedBox(height: 20,),
                          //==================================OTP TEXTFIELD
                          Pinput(
                            controller: _otpController,
                            focusNode: _otpFocusNode,
                            length: 6,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                border: Border.all(color: Theme.of(context).primaryColor),
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
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: (){},
                              child: Text('resend otp',style: TextStyle(color: Theme.of(context).hintColor),),
                            ),
                          ),
                          Text(
                            remainingTime,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 15,),


                          //===============================LOGIN BTN
                          ElevatedButton(
                              onPressed: (){
                                if (_formKey1.currentState!.validate()) {
                                  //_submitOtp(context, appState);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).hintColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                              ),
                              child: Text('Verify',style: TextStyle(color: Theme.of(context).primaryColor),)
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
