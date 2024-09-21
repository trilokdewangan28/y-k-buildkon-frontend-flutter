import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/config/StaticMethod.dart';
import 'package:JAY_BUILDCON/services/ThemeService/theme.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool changeButton =false;
  bool _mounted = false;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool readOnly = false;
  final _otpController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _otpFocusNode = FocusNode();
  
  //----------------------------------------------------------------------------COUNTDOWN VARIABLE
  bool otpSent = false;
  Duration countdownDuration = const Duration(minutes: 5); // Example: 10 minutes
  Timer? countdownTimer;
  String remainingTime = '';
  //----------------------------------------------------------------------------COUNTDOWN METHODS
  void startCountdown() {
    _mounted=true;
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
  String formatDuration(Duration duration) {
    String minutes =
    duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  //----------------------------------------------------------------------------SEND OTP METHODS
  _generateOtpForCustomer(BuildContext context, appState)async{
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
        countdownTimer?.cancel();
        countdownDuration = const Duration(minutes: 5);
        remainingTime = formatDuration(countdownDuration);
        startCountdown();
        readOnly=true;
        StaticMethod.showDialogBar(res['message'], Colors.green);
        appState.activeWidget='LoginWidget';
      }else{
        StaticMethod.showDialogBar(res['message'], Colors.green);
      }
    }

  }

  //----------------------------------------------------------------------------SUBMIT OTP AND LOGIN
  _submitOtpForCustomer(BuildContext context, appState)async{
    _mounted = true;
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
        StaticMethod.showDialogBar(res['message'], Colors.green);
        appState.activeWidget='ProfileWidget';
      }else{
        print("Login Error");
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }

  }


  //----------------------------------------------------------------------------SEND OTP METHODS
  _generateOtpForEmployee(BuildContext context, appState)async{
    remainingTime='';
    //print('send otp called');
    var otpModel = {
      "email":_emailController.text,
    };
    var url = Uri.parse(ApiLinks.sendOtpForEmployeeLogin);
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
        countdownTimer?.cancel();
        countdownDuration = const Duration(minutes: 5);
        remainingTime = formatDuration(countdownDuration);
        startCountdown();
        readOnly=true;
        StaticMethod.showDialogBar(res['message'], Colors.green);
        //appState.activeWidget='LoginWidget';
      }else{
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }

  }

  //----------------------------------------------------------------------------SUBMIT OTP AND LOGIN
  _submitOtpForEmployee(BuildContext context, appState)async{
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
        StaticMethod.showDialogBar(res['message'], Colors.green);
        appState.activeWidget='ProfileWidget';
        setState(() {
        });
      }else{
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }

  }


  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MediaQuery.of(context).size.width/MyConst.referenceWidth;
    return PopScope(
      canPop: false,
        onPopInvoked: (didPop) {
          appState.activeWidget="PropertyListPage";
          appState.currentState=0;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child:
                  Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        'assets/images/ic_launcher.png',
                        height: 180,
                      ),
                      //==============================LOGIN HEADING
                      const SizedBox(
                        width: double.infinity,
                        child: Center(
                            child:Text(
                              "India's #1 Housing Company",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,color: bluishClr
                              ),
                            )
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                       
                       //==============================FORM1 CONTAINER Gen Otp
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _formKey1,
                            child: Column(
                              children: [
                                _emailTextField(),
                                TextButton(
                                    onPressed: (){
                                      if (_formKey1.currentState!.validate()) {
                                        _generateOtpForCustomer(context, appState);
                                      }
                                    },
                                    child: const Text('Generate Otp',style: TextStyle(color: bluishClr),)
                                )
                              ],
                            ),
                          )
                      ),
                      // const SizedBox(height: 15,),

                      const Text('Enter Otp Here', style: TextStyle(fontWeight: FontWeight.w600),),
                      const SizedBox(height: 15,),

                      //==============================FORM2 CONTAINER Login
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _formKey2,
                            child: Column(
                              children: [
                                _pinput(),
                                Text(
                                  remainingTime,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(height: 15,),
                                // ElevatedButton(
                                //     onPressed: (){
                                //       if (_formKey2.currentState!.validate()) {
                                //         _submitOtpForCustomer(context, appState);
                                //       }
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //         backgroundColor: Theme.of(context).primaryColor,
                                //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                //     ),
                                //     child: Text('LOGIN',style: TextStyle(color: Theme.of(context).primaryColorLight, fontWeight: FontWeight.w600),)
                                // ),
                                InkWell(
                                  onTap: ()async{setState(() {

                                  });

                                  if (_formKey2.currentState!.validate()) {
                                    changeButton=true;
                                    _submitOtpForCustomer(context, appState);

                                  }await Future.delayed(const Duration(seconds: 1));
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    width:changeButton?50 : 250,
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        // shape:changeButton?BoxShape.circle:BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(changeButton?50:8)
                                    ),
                                    child: changeButton?const Icon(Icons.done,color: Colors.white,):const Text(
                                      "LOGIN",
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                //================================SIGNUP BTN
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                        "don't have an account ?",
                                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                                    ),
                                    TextButton(
                                        onPressed: (){
                                          appState.activeWidget = "SignupWidget";
                                        },
                                        child:  Text(
                                          'Signup',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).primaryColor
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
          },
        ),
    );
  }
  _emailTextField(){
    return  SizedBox(
      width: MyConst.deviceWidth(context)*0.9,
      child: TextFormField(
        focusNode: _emailFocusNode,
        controller: _emailController,
        readOnly: readOnly,
        style: const TextStyle(),
        decoration:  InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(color: Get.isDarkMode? Colors.grey: Colors.black),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2,
                  color: primaryColor
              ),
              borderRadius: BorderRadius.all(Radius.circular(10),),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: context.theme.primaryColorDark,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10),),
            )
        ),
        validator: (value){
          if(value!.isEmpty || !value.contains("@gmail.com")){
            return "please enter valid email";
          }
          return null;
        },
      ),
    );
  }
  _pinput(){
    return Pinput(
      controller: _otpController,
      focusNode: _otpFocusNode,
      length: 6,
      defaultPinTheme: _pinTheme(),
      focusedPinTheme: _pinTheme().copyWith(
        decoration: _pinTheme().decoration!.copyWith(
          border: Border.all(color: bluishClr,width: 2),
        ),
      ),
      validator: (value){
        if(value!.isEmpty || value.length!=6){
          return "please enter correct otp";
        }
        return null;
      },
      onCompleted: (pin) => debugPrint(pin),
    );
  }
  _pinTheme(){
    return PinTheme(
      width: 55,
      height: 55,
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
  }
}

