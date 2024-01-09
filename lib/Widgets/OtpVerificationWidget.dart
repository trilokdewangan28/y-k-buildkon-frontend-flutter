import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationWidget extends StatefulWidget {
  const OtpVerificationWidget({Key? key}) : super(key: key);

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Colors.black,
    ),
    decoration: BoxDecoration(
      color: Colors.deepPurple.shade100,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.transparent),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                //==============================SIGNUP HEADING
                Container(
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    'SIGNUP NOW',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )),
                ),
                SizedBox(
                  height: 30,
                ),

                //==============================FORM CONTAINER
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      child: Column(
                        children: [
                          //========================MOBILE TEXTFIELD
                          Pinput(
                            length: 5,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                border: Border.all(color: Colors.deepPurple),
                              ),
                            ),
                            onCompleted: (pin) => debugPrint(pin),
                          ),

                          SizedBox(
                            height: 15,
                          ),

                          //===============================SIGNUP BTN
                          ElevatedButton(onPressed: () {}, child: Text('NEXT')),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        )),
        onWillPop: () async {
          return false;
        });
  }
}
