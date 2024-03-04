import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';

import '../../services/ThemeService/theme.dart';
class AdminLoginWidget extends StatefulWidget {
  const AdminLoginWidget({Key? key}) : super(key: key);

  @override
  State<AdminLoginWidget> createState() => _AdminLoginWidgetState();
}

class _AdminLoginWidgetState extends State<AdminLoginWidget> {
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

  _generateOtp(BuildContext context, appState)async{
    remainingTime='';
    //print('send otp called');
    var otpModel = {
      "ad_email":_emailController.text,
    };
    var url = Uri.parse(ApiLinks.sendOtpForAdminLogin);
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
        StaticMethod.showDialogBar(res['message'], Colors.green);
        //appState.activeWidget='LoginWidget';
      }else{
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }

  }

  //----------------------------------------------------------------------------SUBMIT OTP AND LOGIN
  _submitOtp(BuildContext context, appState)async{
    //print('send otp called');
    var otpModel = {
      "ad_email":_emailController.text,
      "ad_otp":_otpController.text
    };
    //print('otp model is');
    //print(otpModel);
    var url = Uri.parse(ApiLinks.verifyOtpForAdminLogin);
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
        appState.storeUserType('admin');
        await Future.delayed(const Duration(milliseconds: 100));
        appState.storeToken(token,'admin');
        await Future.delayed(const Duration(milliseconds: 100));
        appState.fetchUserType();
        await Future.delayed(const Duration(milliseconds: 100));
        appState.fetchToken('admin');
        await Future.delayed(const Duration(milliseconds: 100));
        //--------------------------------------------------------------------
        StaticMethod.showDialogBar(res['message'], Colors.green);
        appState.activeWidget='ProfileWidget';
        appState.currentState=1;
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
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    final defaultPinTheme = PinTheme(
      width: MyConst.deviceHeight(context)*0.056,
      height: MyConst.deviceHeight(context)*0.05,
      textStyle:  TextStyle(
        fontSize: MyConst.mediumTextSize*fontSizeScaleFactor,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(150, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 18, 19, 19),width: 1),
      ),
    );
    return PopScope(
      canPop: false,
        onPopInvoked: (didPop) {
          appState.activeWidget = "PropertyListPage";
          appState.currentState = 0;
        },
        child: Container(
          color: Theme.of(context).primaryColorLight,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child:  Container(
              padding: const EdgeInsets.only(bottom: 250),
              child: Column(
                children: [
                  SizedBox(
                    height: MyConst.deviceHeight(context)*0.2,
                  ),
                  //==============================LOGIN HEADING
                  Container(
                    width: double.infinity,
                    child:  Center(
                        child:Text(
                          'LOGIN NOW',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        )
                    ),
                  ),
                  SizedBox(
                    height: MyConst.mediumSmallTextSize*fontSizeScaleFactor,
                  ),

                  //==============================FORM1 CONTAINER Gen Otp
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: MyConst.deviceHeight(context)*0.02),
                      child: Form(
                        key: _formKey1,
                        child: Column(
                          children: [
                            
                            //============================EMAIL TEXTFIELD
                            _textField(
                                controller: _emailController, 
                                focusNode: _emailFocusNode, 
                                label: 'Email', 
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !value.contains("@gmail.com")) {
                                    return "please enter valid email";
                                  }
                                  return null;
                                }, 
                                inputType: TextInputType.text
                            ),

                            remainingTime==''
                                ? TextButton(
                                onPressed: (){
                                  if (_formKey1.currentState!.validate()) {
                                    _generateOtp(context, appState);
                                  }
                                },
                                child: Text('Generate Otp',style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: MyConst.smallTextSize*fontSizeScaleFactor
                                ),
                                )
                            )
                                : Container(),
                          ],
                        ),
                      )
                  ),
                  SizedBox(height: MyConst.deviceHeight(context)*0.015,),

                  Text('Enter Otp Here', style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MyConst.smallTextSize*fontSizeScaleFactor
                  ),),
                  SizedBox(height: MyConst.deviceHeight(context)*0.015,),

                  //==============================FORM2 CONTAINER Login
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: MyConst.deviceHeight(context)*0.02),
                      child: Form(
                        key: _formKey2,
                        child: Column(
                          children: [
                            //==================================OTP TEXTFIELD
                            _pinput(),
                            Text(
                              remainingTime,
                              style:  TextStyle(fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                            ),
                            SizedBox(height: MyConst.deviceHeight(context)*0.015,),


                            //===============================LOGIN BTN
                            ElevatedButton(
                                onPressed: (){
                                  if (_formKey2.currentState!.validate()) {
                                    _submitOtp(context, appState);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                ),
                                child: Text('LOGIN',style: TextStyle(color: Theme.of(context).primaryColorLight, fontWeight: FontWeight.w600),)
                            ),
                            SizedBox(height: MyConst.deviceHeight(context)*0.015,),

                          ],
                        ),
                      )
                  ),

                ],
              ),
            ),
          ),
        )
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
          border: Border.all(color: Theme.of(context).primaryColor,width: 2),
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
              color: primaryColorDark,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        validator: validator);
  }
}
