import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Widgets/Employee/OtpVerificationWidgetForEmployee.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';

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
      "referal_code":_referalCodeController.text
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
        Fluttertoast.showToast(
          msg: res['message'],
          toastLength: Toast.LENGTH_LONG, // Duration for which the toast should be visible
          gravity: ToastGravity.TOP, // Toast position
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.green, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerificationWidgetForEmployee(employeeData: employeeData,)));
      } else {
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
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor =
        MyConst.deviceWidth(context) / MyConst.referenceWidth;
    return PopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Employee Joining'),
            centerTitle: true,
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  //====================================HEADING
                  Center(
                    child: Text(
                      'Employee Signup',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: MyConst.largeTextSize * fontSizeScaleFactor),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //===============================FORM CONTAINER
                  Container(
                      width: MyConst.deviceWidth(context),
                      decoration: BoxDecoration(
                        //border: Border.all(width: 1),
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Joiner Details',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //=============================NAME TEXTFIELD
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                  labelText: 'Full Name',
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
                                  return 'please enter valid input';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================CONTACT TEXTFIELD
                            TextFormField(
                              controller: _contactController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Contact Number',
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
                                if (value!.isEmpty || value.length != 10) {
                                  return 'please enter valid contact number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================EMAIL TEXTFIELD
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: 'Email',
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
                                if (value!.isEmpty ||
                                    !value.contains('@gmail.com')) {
                                  return 'please enter valid email';
                                }
                                return null;
                              },
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
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              width: MyConst.deviceWidth(context) * 0.85,
                              height: 65,
                              decoration: BoxDecoration(
                                  border:
                                  Border.all(width: 1, color: Colors.black54),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Text('Blood Group:'),
                                  Spacer(),
                                  Card(
                                      color: Theme.of(context).primaryColorLight,
                                      elevation: 0.5,
                                      child: Container(
                                          width: MyConst.deviceWidth(context) * 0.3,
                                          height:
                                          MyConst.deviceHeight(context) * 0.06,
                                          margin:
                                          EdgeInsets.symmetric(horizontal: 4),
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
                            TextFormField(
                              controller: _educationController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: 'Education',
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
                                  return 'please enter valid input';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================PROFESSION TEXTFIELD
                            TextFormField(
                              controller: _professionController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: 'Profession',
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
                                  return 'please enter valid input';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=============================INTEREST TEXTFIELD
                            TextFormField(
                              controller: _interestController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: 'Interest In Real Estate',
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
                                  return 'please enter valid input';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //============================FATHER NAME
                            TextFormField(
                              controller: _fnameController,
                              decoration: InputDecoration(
                                  labelText: 'Father`s Name',
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
                                  return 'please enter valid input';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=========================== MOTHER NAME
                            TextFormField(
                              controller: _mnameController,
                              decoration: InputDecoration(
                                  labelText: 'Mother`s Name',
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
                                  return 'please enter valid input';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=========================== ADDRESS TEXTFILED
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                  labelText: 'Address',
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
                                  return 'please enter valid address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=========================== CITY TEXTFILED
                            TextFormField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                  labelText: 'City',
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
                                  return 'please enter valid city';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=========================== STATE TEXTFILED
                            TextFormField(
                              controller: _stateController,
                              decoration: InputDecoration(
                                  labelText: 'State',
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
                                  return 'please enter valid state';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //=========================== PINCODE TEXTFILED
                            TextFormField(
                              controller: _pincodeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Pincode',
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
                                  return 'please enter valid pincode';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Text(
                              'Nominee Details',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //=============================NOMINEE NAME TEXTFIELD
                            TextFormField(
                              controller: _nomineeNameController,
                              decoration: InputDecoration(
                                  labelText: 'Nominee Name',
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
                                  return 'please enter valid input';
                                }
                                return null;
                              },
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
                            TextFormField(
                              controller: _nomineeRelationController,
                              decoration: InputDecoration(
                                  labelText: 'Relation',
                                  // labelStyle: TextStyle(
                                  //     color: Theme.of(context).primaryColorDark
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
                                  return 'please enter valid input';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            //=============================NOMINEE RELATION TEXTFIELD
                            TextFormField(
                              controller: _referalCodeController,
                              decoration: InputDecoration(
                                  labelText: 'Referal Code',
                                  // labelStyle: TextStyle(
                                  //     color: Theme.of(context).primaryColorDark
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
                                  return 'please enter valid input';
                                }
                                return null;
                              },
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
                                          .showSnackBar(SnackBar(
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
                                          .showSnackBar(SnackBar(
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
                                  Text(
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
                                    style: TextStyle(

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
                                          .showSnackBar(SnackBar(
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

                            SizedBox(
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
}
