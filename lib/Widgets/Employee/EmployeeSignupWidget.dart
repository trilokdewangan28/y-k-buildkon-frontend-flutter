import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Employee/OtpVerificationWidgetForEmployee.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/services/theme.dart';

class EmployeeSignupWidget extends StatefulWidget {
  const EmployeeSignupWidget({super.key});

  @override
  State<EmployeeSignupWidget> createState() => _EmployeeSignupWidgetState();
}

class _EmployeeSignupWidgetState extends State<EmployeeSignupWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _mounted = false;
  List<String> bloodGroup = [
    'O+ve',
    'O-ve',
    'A+ve',
    'A-ve',
    'B+ve',
    'B-ve',
    'AB+ve',
    'AB-ve'
  ];
  bool isDeclarationChecked = false;
  bool isShowDeclaration = false;

  //==============================ALL PERSONAL CONTROLLERS
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _joinerDobController = TextEditingController();
  String selectedBloodGroup = 'O+ve';
  final _educationController = TextEditingController();
  final _professionController = TextEditingController();
  final _interestController = TextEditingController();
  final _fnameController = TextEditingController();
  final _mnameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _referalCodeController = TextEditingController();
  String employeeCodeTemp = "YKE";
  String employeeCode = "";

  //===========================================NOMINEE CONTROLLER
  final _nomineeNameController = TextEditingController();
  final _nomineeDobController = TextEditingController();
  final _nomineeRelationController = TextEditingController();

  //===========================================DATE VARIABLE
  DateTime selectedDate = DateTime.now().subtract(const Duration(days: 1));
  final DateTime lastSelectableDate =
      DateTime.now().subtract(const Duration(days: 1));
  final DateTime firstSelectableDate =
      DateTime.now().subtract(const Duration(days: 100000));

  //=================================================================DATE PICKER
  Future<void> _selectDateForJoiner(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstSelectableDate,
        lastDate: lastSelectableDate);

    if (picked != null && picked != selectedDate) {
      if (_mounted) {
        setState(() {
          selectedDate = picked;
          _joinerDobController.text = '${selectedDate.toLocal()}'.split(' ')[0];
        });
      }
    }
  }

  //=================================================================DATE PICKER
  Future<void> _selectDateForNominee(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstSelectableDate,
        lastDate: lastSelectableDate);

    if (picked != null && picked != selectedDate) {
      if (_mounted) {
        setState(() {
          selectedDate = picked;
          _nomineeDobController.text =
              '${selectedDate.toLocal()}'.split(' ')[0];
        });
      }
    }
  }

  //================================================SEND OTP
  _sendOtpForEmployeeSignup(appState, context) async {
    generateEmployeeCode(_nameController.text, _contactController.text);
    var employeeData = {
      "name": _nameController.text,
      "mobile": _contactController.text,
      "email": _emailController.text,
      "dob": _joinerDobController.text,
      "blood_group": selectedBloodGroup,
      "education":_educationController.text,
      "profession":_professionController.text,
      "interest":_interestController.text,
      "fname":_fnameController.text,
      "mname":_mnameController.text,
      "address":_addressController.text,
      "city":_cityController.text,
      "state": _stateController.text,
      "pincode": _pincodeController.text,
      "nominee_name":_nomineeNameController.text,
      "nominee_dob":_nomineeDobController.text,
      "relation":_nomineeRelationController.text,
      "referal_code":_referalCodeController.text,
      "employee_code":employeeCode
    };
    
    var url = Uri.parse(ApiLinks.sendOtpForEmployeeSignup);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.sendOtpForSignup(employeeData, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerificationWidgetForEmployee(employeeData: employeeData,)));
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  //==================================================GENERATE EMPLOYEE CODE
  void generateEmployeeCode(fullName, mobileNumber) {
    String firstInitial = fullName.split(' ').first[0];
    String lastInitial = fullName.split(' ').last[0];

    String initials = firstInitial.toUpperCase() + lastInitial.toUpperCase();

    String mobileString = mobileNumber.toString();
    String lastFive = mobileString.substring(mobileString.length - 5);

    employeeCode = employeeCodeTemp + initials + lastFive;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor =
        MyConst.deviceWidth(context) / MyConst.referenceWidth;
    return PopScope(
        child: Scaffold(
          backgroundColor: primaryColorLight,
          appBar: _appBar('Employee Joining'),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  //====================================HEADING
                  Center(
                    child: Text(
                      'Signup Form',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),
                    ),
                  ),

                  //===============================FORM CONTAINER
                  Container(
                      width: MyConst.deviceWidth(context),
                      decoration: BoxDecoration(
                          //color: primaryColor.withOpacity(0.08),
                        border: Border.all(width: 1,color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              'Applicants Details',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            //=============================NAME TEXTFIELD
                            _textField(
                                controller: _nameController,
                                label: 'Full Name', 
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid name';
                                  }
                                  return null;
                                }, 
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================CONTACT TEXTFIELD
                            _textField(
                                controller: _contactController,
                                label: 'Contact Number',
                                validator: (value) {
                                  if (value!.isEmpty || value.length!=10) {
                                    return 'please enter valid contact number';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.number
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================EMAIL TEXTFIELD
                            _textField(
                                controller: _emailController,
                                label: 'Email',
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !value.contains('@gmail.com')) {
                                    return 'please enter valid email';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================DOB TEXTFIELD
                            TextFormField(
                              controller: _joinerDobController,
                              onTap: () {
                                _mounted = true;
                                _selectDateForJoiner(context);
                              },
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelText: 'Date Of Birth',
                                  // labelStyle: TextStyle(
                                  //     color: Theme.of(context).primaryColor
                                  // ),
                                  focusColor: Theme.of(context).primaryColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10))),
                              cursorColor: Theme.of(context).primaryColor,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter valid date';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================BLOOD GROUP DROPDOWN
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              width: MyConst.deviceWidth(context) * 0.85,
                              height: 65,
                              decoration: BoxDecoration(
                                  border:
                                  Border.all(width: 1, color: Colors.black54),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  const Text('Blood Group:'),
                                  const Spacer(),
                                  Card(
                                      color: Theme.of(context).primaryColorLight,
                                      elevation: 0.5,
                                      child: Container(
                                          width: MyConst.deviceWidth(context) * 0.3,
                                          height:
                                          MyConst.deviceHeight(context) * 0.06,
                                          margin:
                                          const EdgeInsets.symmetric(horizontal: 4),
                                          child: Center(
                                            child: DropdownButton<String>(
                                              value: selectedBloodGroup,
                                              alignment: Alignment.center,
                                              elevation: 16,
                                              underline: Container(),
                                              onChanged: (String? value) {
                                                // This is called when the user selects an item.
                                                setState(() {
                                                  selectedBloodGroup = value!;
                                                  //print('selected property type is ${selectedPropertyType}');
                                                });
                                              },
                                              ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                                              items: bloodGroup
                                                  .map<DropdownMenuItem<String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text('${value}',
                                                          softWrap: true,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: MyConst
                                                                  .smallTextSize *
                                                                  fontSizeScaleFactor,
                                                              overflow: TextOverflow
                                                                  .ellipsis)),
                                                    );
                                                  }).toList(),
                                            ),
                                          ))),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================EDUCATION TEXTFIELD
                            _textField(
                                controller: _educationController,
                                label: 'Education',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================PROFESSION TEXTFIELD
                            _textField(
                                controller: _professionController,
                                label: 'Profession',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================INTEREST TEXTFIELD
                            _textField(
                                controller: _interestController,
                                label: 'Interest',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //============================FATHER NAME
                            _textField(
                                controller: _fnameController,
                                label: 'Father Name',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=========================== MOTHER NAME
                            _textField(
                                controller: _mnameController,
                                label: 'Mother Name',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=========================== ADDRESS TEXTFILED
                            _textField(
                                controller: _addressController,
                                label: 'Address',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=========================== CITY TEXTFILED
                            _textField(
                                controller: _cityController,
                                label: 'City',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=========================== STATE TEXTFILED
                            _textField(
                                controller: _stateController,
                                label: 'State',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=========================== PINCODE TEXTFILED
                            _textField(
                                controller: _pincodeController,
                                label: 'Pincode',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.number
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            const Text(
                              'Nominee Details',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            //=============================NOMINEE NAME TEXTFIELD
                            _textField(
                                controller: _nomineeNameController,
                                label: 'Nominee Name',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================NOMINEE DOB TEXTFIELD
                            TextFormField(
                              controller: _nomineeDobController,
                              onTap: () {
                                _mounted = true;
                                _selectDateForNominee(context);
                              },
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelText: 'Date Of Birth',
                                  // labelStyle: TextStyle(
                                  //     color: Theme.of(context).primaryColor
                                  // ),
                                  focusColor: Theme.of(context).primaryColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10))),
                              cursorColor: Theme.of(context).primaryColor,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter valid date';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================NOMINEE RELATION TEXTFIELD
                            _textField(
                                controller: _nomineeRelationController,
                                label: 'Relation',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            //=============================REFERALCODE TEXTFIELD
                            _textField(
                                controller: _referalCodeController,
                                label: 'Referal Code',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            //=============================CHECKBOX AND DECLARATION BUTTON
                            Row(
                              children: [
                                Checkbox(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: isDeclarationChecked,
                                  onChanged: (bool? value) {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isDeclarationChecked = value!;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                            'please fill all the details',
                                            style: TextStyle(color: Colors.red),
                                          )));
                                    }
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(),
                                  onPressed: (){
                                    if(_formKey.currentState!.validate()){
                                      setState(() {
                                        isShowDeclaration=!isShowDeclaration;
                                      });
                                    }else{
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                            'firstly check the declaration',
                                            style: TextStyle(color: Colors.red),
                                          )));
                                    }
                                  },
                                  child: Text(
                                    'Self Declaration',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //=============================DECLARATION CONTENT
                            isShowDeclaration
                                ? Container(
                              child: Column(
                                children: [
                                  const Text(
                                    'Declaration',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    'Personally Came and appeared before me, the undersigned notary the within named'
                                        ' "${_nameController.text}" who is resident of INDIA country. State of "${_stateController.text}" '
                                        'and make this his/her statement and General Affidavit upon other and affirmation'
                                        'of belief and personal knowledge that the following matters. facts and things set forth'
                                        'are true and correct to the best of his/her knowledge.',
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(

                                    ),

                                  )
                                ],
                              ),
                            )
                                : Container(),


                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                onPressed: (){
                                  if (_formKey.currentState!.validate()) {
                                    if(isDeclarationChecked){
                                      //// _submit the data
                                      _sendOtpForEmployeeSignup(appState, context);
                                    }else{
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                            'please check the declaration',
                                            style: TextStyle(color: Colors.red),
                                          )));
                                    }
                                  }
                                },
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorLight,
                                      fontWeight: FontWeight.w600
                                  ),
                                )
                            ),

                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        )
    );
  }
  _textField(
      {required TextEditingController? controller,
         FocusNode? focusNode,
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
  _appBar(appBarContent){
    return AppBar(
      foregroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color:Colors.black,
        size: MyConst.deviceHeight(context)*0.030,
      ),
      toolbarHeight: MyConst.deviceHeight(context)*0.060,
      titleSpacing: MyConst.deviceHeight(context)*0.02,
      elevation: 0.0,
      title:Text(
        appBarContent,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: MyConst.mediumTextSize*fontSizeScaleFactor(context),
            overflow: TextOverflow.ellipsis),
        softWrap: true,
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/ic_launcher.png'
            ),
          ),
        )
      ],
      backgroundColor: primaryColorLight,
    );
  }
}
