import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:JAY_BUILDCON/controller/MyProvider.dart';
import 'package:JAY_BUILDCON/config/ApiLinks.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';
import 'package:JAY_BUILDCON/config/StaticMethod.dart';
import 'package:JAY_BUILDCON/services/ThemeService/theme.dart';


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
      //print(res);
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green);
        // appState.activeWidget = "P";
        // appState.currentState = 0;
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
        print(res);
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
    return PopScope(
      canPop: false,
        onPopInvoked: (didPop) {
          appState.activeWidget="ProfileWidget";
        },
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 250),
              child: Column(
                children: [
                  
                  const SizedBox(
                    height: 20,
                  ),
                  //==============================SIGNUP HEADING
                  const SizedBox(
                    width: double.infinity,
                    child: Center(
                        child: Text(
                          'New Project',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
                            _textField(
                                controller: _projectNameController, 
                                focusNode: _projectNameFocusNode, 
                                label: 'Project Name', 
                                inputType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter valid input';
                                }
                                return null;
                              }
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            //========================PROJECT UNIQUE NUMBER TEXTFIELD
                            _textField(
                                controller: _projectUnController,
                                focusNode: _projectUnFocusNode,
                                label: 'Project Unique Number',
                                inputType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                }
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            //===============================LOCALITY AND CITY
                            Row(
                              children: [
                                Expanded(
                                  child: _textField(
                                      controller: _projectLocalityController,
                                      focusNode: _projectLocalityFocusNode,
                                      label: 'Locality',
                                      inputType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'please enter valid input';
                                        }
                                        return null;
                                      }
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: _textField(
                                      controller: _projectCityController,
                                      focusNode: _projectCityFocusNode,
                                      label: 'City',
                                      inputType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'please enter valid input';
                                        }
                                        return null;
                                      }
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            //===========================PINCODE TEXTFIELD
                            _textField(
                                controller: _projectPincodeController,
                                focusNode: _projectPincodeFocusNode,
                                label: 'Pincode',
                                inputType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                }
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            //===========================STATE TEXTFIELD
                            _textField(
                                controller: _projectStateController,
                                focusNode: _projectStateFocusNode,
                                label: 'State',
                                inputType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                }
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            //===============================ADD PROJECT BUTTON
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: bluishClr,
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
                                  'Add Project',
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
        )
    );
  }
  _textField({
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required String? label,
    required TextInputType? inputType,
    validator,
    maxline=1
  }){
    return TextFormField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxline,
        decoration:  InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Get.isDarkMode?Colors.white70:Colors.black),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2,
                  color:bluishClr
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            )),
        validator:validator
    );
  }
}
