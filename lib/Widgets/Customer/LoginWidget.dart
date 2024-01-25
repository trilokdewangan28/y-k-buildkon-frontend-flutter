import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/StaticMethod.dart';
class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool readOnly = false;
  final _otpController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
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

  //----------------------------------------------------------------------------SEND OTP METHODS

  _generateOtp(BuildContext context, appState)async{
    remainingTime='';
    //print('send otp called');
    var otpModel = {
      "c_email":_emailController.text,
    };
    var url = Uri.parse(ApiLinks.sendOtpForLogin);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.generateOtp(otpModel,url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        startCountdown();
        readOnly=true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: const TextStyle(color: Colors.green),)));
        appState.activeWidget='LoginWidget';
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: const TextStyle(color: Colors.red),)));
      }
    }

  }

  //----------------------------------------------------------------------------SUBMIT OTP AND LOGIN
  _submitOtp(BuildContext context, appState)async{
    //print('send otp called');
    var otpModel = {
      "c_email":_emailController.text,
      "c_otp":_otpController.text
    };
    //print('otp model is');
    //print(otpModel);
    var url = Uri.parse(ApiLinks.verifyOtpForLogin);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.submitOtpAndLogin(otpModel,url);
    if(res.isNotEmpty){
      Navigator.pop(context);
      if(res['success']==true){
        startCountdown();
        readOnly=true;
        //print('response data is');
        //print(res['token']);
        final token = res['token'];
        //-----------------------------------storing customer sensitive data
        appState.storeUserType('customer');
        await Future.delayed(const Duration(milliseconds: 100));
        appState.storeToken(token,'customer');
        await Future.delayed(const Duration(milliseconds: 100));
        appState.fetchUserType();
        await Future.delayed(const Duration(milliseconds: 100));
        appState.fetchToken('customer');
        await Future.delayed(const Duration(milliseconds: 100));
        //--------------------------------------------------------------------
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: const TextStyle(color: Colors.green),)));
        appState.activeWidget='ProfileWidget';
        setState(() {
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['message']}', style: const TextStyle(color: Colors.red),)));
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child:  Container(
          padding: const EdgeInsets.only(bottom: 250),
          child: Column(
            children: [
              // const SizedBox(
              //   height: 60,
              // ),
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                color: Theme.of(context).hintColor,
              ),
              Container(
                width: double.infinity,
                child: const Center(
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
                height: 30,
              ),
              //==============================LOGIN HEADING
              Container(
                width: double.infinity,
                child: const Center(
                    child:Text(
                      'LOGIN NOW',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    )
                ),
              ),
              const SizedBox(
                height: 16,
              ),

              //==============================FORM1 CONTAINER Gen Otp
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey1,
                    child: Column(
                      children: [
                        //========================MOBILE TEXTFIELD
                        /*
                          Card(
                            elevation: 5,
                            child:TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Mobile Number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  )
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          */

                        //============================EMAIL TEXTFIELD
                        TextFormField(
                          focusNode: _emailFocusNode,
                          controller: _emailController,
                          readOnly: readOnly,
                          style: const TextStyle(),
                          decoration:  const InputDecoration(
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

                        remainingTime == ''
                            ? TextButton(
                            onPressed: (){
                              if (_formKey1.currentState!.validate()) {
                                _generateOtp(context, appState);
                              }
                            },
                            child: Text('Generate Otp',style: TextStyle(color: Theme.of(context).hintColor),)
                        )
                            : Container(),
                      ],
                    ),
                  )
              ),
              const SizedBox(height: 15,),

              const Text('Enter Otp Here', style: TextStyle(fontWeight: FontWeight.w600),),
              const SizedBox(height: 15,),

              //==============================FORM2 CONTAINER Login
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey2,
                    child: Column(
                      children: [
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
                        Text(
                          remainingTime,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 15,),


                        //===============================LOGIN BTN
                        ElevatedButton(
                            onPressed: (){
                              if (_formKey2.currentState!.validate()) {
                                _submitOtp(context, appState);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).hintColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                            child: Text('LOGIN',style: TextStyle(color: Theme.of(context).primaryColor),)
                        ),
                        const SizedBox(height: 15,),

                        //================================SIGNUP BTN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'dont have an account ?'
                            ),
                            TextButton(
                                onPressed: (){
                                  appState.activeWidget = "SignupWidget";
                                },
                                child:  Text(
                                  'Signup',
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
              ),

            ],
          ),
        ),
      ),
    );


  }
}
