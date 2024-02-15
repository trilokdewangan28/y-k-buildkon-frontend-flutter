import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Employee/EmployeeSignupWidget.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
class EmployeeLoginWidget extends StatefulWidget {
  const EmployeeLoginWidget({Key? key}) : super(key: key);

  @override
  State<EmployeeLoginWidget> createState() => _EmployeeLoginWidgetState();
}

class _EmployeeLoginWidgetState extends State<EmployeeLoginWidget> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool _mounted = false;
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
        Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
          gravity: ToastGravity.TOP, // Toast position
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.green, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
        //appState.activeWidget='LoginWidget';
      }else{
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

  //----------------------------------------------------------------------------SUBMIT OTP AND LOGIN
  _submitOtpForEmployee(BuildContext context, appState)async{
    //print('send otp called');
    var otpModel = {
      "email":_emailController.text,
      "otp":_otpController.text
    };
    //print('otp model is');
    //print(otpModel);
    var url = Uri.parse(ApiLinks.verifyOtpForEmployeeLogin);
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
        appState.storeUserType('employee');
        await Future.delayed(const Duration(milliseconds: 100));
        appState.storeToken(token,'employee');
        await Future.delayed(const Duration(milliseconds: 100));
        appState.fetchUserType();
        await Future.delayed(const Duration(milliseconds: 100));
        appState.fetchToken('employee');
        await Future.delayed(const Duration(milliseconds: 100));
        //print(appState.userType);
        //print(appState.token);
        //--------------------------------------------------------------------
        Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
          gravity: ToastGravity.TOP, // Toast position
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.green, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
        if(mounted){
          Navigator.pop(context); 
        }
        appState.activeWidget='ProfileWidget';
        
      }else{
        //print(res);
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
                  // const SizedBox(
                  //   height: 60,
                  // ),
                  Image.asset(
                    'assets/images/ic_launcher.png',
                    height: 150,

                  ),
                  Container(
                    width: double.infinity,
                    child: Center(
                        child:Text(
                          'Welcome To Y&K Buildkon',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: MyConst.mediumSmallTextSize*fontSizeScaleFactor
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
                              decoration:  InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Theme.of(context).primaryColor
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
                              validator: (value){
                                if(value!.isEmpty || !value.contains("@gmail.com")){
                                  return "please enter valid email";
                                }
                                return null;
                              },
                            ),

                            TextButton(
                                onPressed: (){
                                  if (_formKey1.currentState!.validate()) {
                                    _generateOtpForEmployee(context, appState);
                                  }
                                },
                                child: Text('Generate Otp',style: TextStyle(color: Theme.of(context).primaryColor),)
                            )

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
                            Text(
                              remainingTime,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 15,),


                            //===============================CUSTOMER LOGIN BTN
                            Container(
                              child: ElevatedButton(
                                  onPressed: (){
                                    if (_formKey2.currentState!.validate()) {
                                      _submitOtpForEmployee(context, appState);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                  ),
                                  child: Text('EMPLOYEE LOGIN',style: TextStyle(color: Theme.of(context).primaryColorLight, fontWeight: FontWeight.w600),)
                              ),
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const EmployeeSignupWidget()));
                                    },
                                    child:  Text(
                                      'Signup',
                                      style: TextStyle(
                                          fontSize: 16,
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
        )   
    );


  }
}
