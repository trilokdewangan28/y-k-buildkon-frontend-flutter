import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
class AddNewProjectWidget extends StatefulWidget {
  const AddNewProjectWidget({super.key});

  @override
  State<AddNewProjectWidget> createState() => _AddNewProjectWidgetState();
}

class _AddNewProjectWidgetState extends State<AddNewProjectWidget> {
  final _formKey = GlobalKey<FormState>();

  //===================================ALL THE FORM CONTROLLERS
  final _projectNameController = TextEditingController();
  final _projectUnController = TextEditingController();
  final _projectLocalityController = TextEditingController();
  final _projectCityController = TextEditingController();
  final _projectStateController = TextEditingController();
  final _projectPincodeController = TextEditingController();

  final FocusNode _projectNameFocusNode = FocusNode();
  final FocusNode _projectUnFocusNode = FocusNode();
  final FocusNode _projectLocalityFocusNode = FocusNode();
  final FocusNode _projectCityFocusNode = FocusNode();
  final FocusNode _projectStateFocusNode = FocusNode();
  final FocusNode _projectPincodeFocusNode = FocusNode();

  _submitData(appState, context) async {
    var propertyData = {
      "project_name": _projectNameController.text,
      "project_un": _projectUnController.text,
      "project_city": _projectCityController.text,
      "project_locality": _projectLocalityController.text,
      "project_state": _projectStateController.text,
      "project_pincode": _projectPincodeController.text,
    };
    var url = Uri.parse(ApiLinks.insertProjectDetails);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.insertProperty(appState.token, propertyData, url);
    if (res.isNotEmpty) {
      print(res);
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
        // appState.activeWidget = "P";
        // appState.currentState = 0;
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
  Widget build(BuildContext context)  {
    final appState = Provider.of<MyProvider>(context);
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    final dropDownCardHeight = MyConst.deviceHeight(context) * 0.06;
    final dropDownCardWidth = MyConst.deviceWidth(context) * 0.41;
    double smallBodyText = 14;
    return Container(
      color: Theme.of(context).primaryColorLight,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 250),
          child: Column(
            children: [
              Image.asset(
                'assets/images/ic_launcher.png',
                height: 150,

              ),
              Container(
                width: double.infinity,
                child: const Center(
                    child: Text(
                      'Welcome To Y&K Buildkon',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              //==============================SIGNUP HEADING
              Container(
                width: double.infinity,
                child: const Center(
                    child: Text(
                      'New Prject',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),

              //==============================FORM CONTAINER
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //=============================PROPERTY NAME TEXTFIELD
                        TextFormField(
                            focusNode: _projectNameFocusNode,
                            controller: _projectNameController,
                            decoration: const InputDecoration(
                                labelText: 'Project Name',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    // color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter valid project name';
                              }
                              return null;
                            }),

                        const SizedBox(
                          height: 15,
                        ),

                        //========================PROJECT UNIQUE NUMBER TEXTFIELD
                        TextFormField(
                            focusNode: _projectUnFocusNode,
                            controller: _projectUnController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Project Unique Number',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    // color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter valid unique number';
                              }
                              return null;
                            }),

                        const SizedBox(
                          height: 15,
                        ),
                        
                        //===============================LOCALITY AND CITY
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                  focusNode: _projectLocalityFocusNode,
                                  controller: _projectLocalityController,
                                  decoration: const InputDecoration(
                                      labelText: 'Locality',
                                      labelStyle:
                                      TextStyle(color: Colors.black),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          // color: Theme.of(context).hintColor
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      )),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter valid locality';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                  focusNode: _projectCityFocusNode,
                                  controller: _projectCityController,
                                  decoration: const InputDecoration(
                                      labelText: 'City',
                                      labelStyle:
                                      TextStyle(color: Colors.black),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          // color: Theme.of(context).hintColor
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      )),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter valid city name';
                                    }
                                    return null;
                                  }),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        //===========================PINCODE TEXTFIELD
                        TextFormField(
                            focusNode: _projectPincodeFocusNode,
                            controller: _projectPincodeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Pincode',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    // color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            validator: (value) {
                              if (value!.isEmpty || value.length != 6) {
                                return 'please enter valid pincode';
                              }
                              return null;
                            }),

                        const SizedBox(
                          height: 15,
                        ),
                        
                        //===========================STATE TEXTFIELD
                        TextFormField(
                            focusNode: _projectStateFocusNode,
                            controller: _projectStateController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'State',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    // color: Theme.of(context).hintColor
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter valid State';
                              }
                              return null;
                            }),

                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        //===============================ADD PROJECT BUTTON
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _submitData(appState, context);
                              }
                            },
                            child: Text(
                              'Add Properties',
                              style:
                              TextStyle(color: Theme.of(context).primaryColorLight, fontWeight: FontWeight.w600),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
