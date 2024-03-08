import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/services/ThemeService/theme.dart';


class EmiCalculatorWidget extends StatefulWidget {
  const EmiCalculatorWidget({Key? key}) : super(key: key);

  @override
  State<EmiCalculatorWidget> createState() => _EmiCalculatorWidgetState();
}

class _EmiCalculatorWidgetState extends State<EmiCalculatorWidget> {
  final _formKey = GlobalKey<FormState>();
  final _principleAmmountController = TextEditingController();
  final FocusNode _principleAmmountFocusNode = FocusNode();

  final _downPaymentController = TextEditingController();
  final FocusNode _downPaymentFocusNode = FocusNode();

  final _interestController = TextEditingController();
  final FocusNode _interestFocusNode = FocusNode();

  final _timeController = TextEditingController();
  final FocusNode _timeFocusNode = FocusNode();

  double monthlyEmi = 0.0;

  double calculateEMI(double principalAmount, double downPayment,
      int loanTenureInYears, double annualInterestRate) {
    // Calculate loan amount (principal - down payment)
    double loanAmount = principalAmount - downPayment;

    // Convert annual interest rate to monthly interest rate
    double monthlyInterestRate = (annualInterestRate / 12) / 100;

    // Calculate total number of monthly installments (loan tenure in years * 12)
    int totalInstallments = loanTenureInYears * 12;

    // Calculate EMI using the formula
    double emi = loanAmount *
        monthlyInterestRate *
        pow(1 + monthlyInterestRate, totalInstallments) /
        (pow(1 + monthlyInterestRate, totalInstallments) - 1);
    return emi;
  }

  @override
  Widget build(BuildContext context) {
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    return PopScope(
      
        child: Scaffold(
          backgroundColor: context.theme.backgroundColor,
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){Get.back();},
              icon: Icon(Icons.arrow_back_ios),
            ),
            backgroundColor:context.theme.backgroundColor,
            title:  Text('EMI CALCULATOR',style: appbartitlestyle,),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: _textField(
                          controller: _principleAmmountController, 
                          focusNode: _principleAmmountFocusNode, 
                          label: "Principle Amount", 
                          inputType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter valid principle ammount';
                          }
                          return null;
                        }
                      )
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: _textField(
                          controller: _downPaymentController, 
                          focusNode: _downPaymentFocusNode, 
                          label: 'Down Payment', 
                          inputType: TextInputType.number,
                        validator: (value) {
                          double dp = double.tryParse(value.toString()) ?? 0.0;
                          double pam =
                              double.tryParse(_principleAmmountController.text) ??
                                  0.0;
                          if (value!.isEmpty || dp > pam) {
                            return 'down payment should be less than principle amount';
                          }
                          return null;
                        }
                      )
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: _textField(
                                controller: _interestController,
                                focusNode: _interestFocusNode,
                                label: "Interest Rate",
                                inputType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid interest';
                                  }
                                  return null;
                                }
                            )
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: _textField(
                                controller: _timeController,
                                focusNode: _timeFocusNode,
                                label: "time in year",
                                inputType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid time';
                                  }
                                  return null;
                                }
                            )
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          const Expanded(
                              child: Text(
                                'Monthly EMI: ',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                              )),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.08,
                                decoration: BoxDecoration(
                                    color: Colors.white54,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Text(
                                      '₹ ${monthlyEmi.ceil().toString()} ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: Theme.of(context).primaryColor),
                                    ))),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bluishClr,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            double principalAmount =
                                double.tryParse(_principleAmmountController.text) ??
                                    0.0;
                            double downPayment =
                                double.tryParse(_downPaymentController.text) ?? 0.0;
                            int loanTenureInYears =
                                int.tryParse(_timeController.text) ?? 0;
                            double annualInterestRate =
                                double.tryParse(_interestController.text) ?? 0.0;
                            monthlyEmi = calculateEMI(principalAmount, downPayment,
                                loanTenureInYears, annualInterestRate);
                            setState(() {});
                          }
                        },
                        child: Text(
                          'Calculate EMI',
                          style: titleStyle,
                        ))
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
  _textField({
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required String? label,
    required TextInputType inputType,
    validator
}){
    return  Container(
      width: MyConst.deviceWidth(context)*0.9,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: inputType,
        decoration:  InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Get.isDarkMode? Colors.grey: Colors.black),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2,
                  color: primaryColor
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10),),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: context.theme.primaryColorDark,
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
    );
  }
}
