import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';
import 'package:real_state/services/ThemeService/theme.dart';

class AddNewPropertyWidget extends StatefulWidget {
  const AddNewPropertyWidget({Key? key}) : super(key: key);

  @override
  State<AddNewPropertyWidget> createState() => _AddNewPropertyWidgetState();
}

class _AddNewPropertyWidgetState extends State<AddNewPropertyWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _mounted = false;
  bool _isProjectLoading = false;
  int? selectedId;
  String selectedName='';
  List<dynamic> projectList = [];

  //==========================================first load method
  _fetchProject(appState)async{
    if(_mounted){
      setState(() {
        _isProjectLoading= true;
      });
    }
    var url = Uri.parse(ApiLinks.fetchProject);
    final res = await StaticMethod.fetchProject(url);

    if (res.isNotEmpty) {
      if (res['success'] == true) {
        //print('succes is true and result is ${res['result']}');
        projectList = res['result'];
        if(_mounted){
          setState(() {
            _isProjectLoading = false;
          });
        }
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.green);
      }
    }
  }



  final List<String> propertyType = [
    'House',
    'Flat',
    'Plot',
    'Office Space',
    'Shop/Showroom',
    'Commercial Land'
  ];
  String selectedPropertyType = "House";

  final List<String> bhk = ['0', '1', '2', '3', '4', '5'];
  int selectedBhk = 0;

  final List<String> floor = ['0', '1', '2', '3', '4', '5'];
  int selectedFloor = 0;

  final List<String> garden = ['Yes', 'No'];
  String selectedGarden = 'No';

  final List<String> parking = ['Yes', 'No'];
  String selectedParking = 'No';

  final List<String> furnished = ['Yes', 'No'];
  String selectedFurnished = "No";

  final List<String> available = ['None', 'Available', 'Not Available','Sold'];
  String selectedAvailability = "Available";

  final List<String> areaUnits=['Square Feet','Acre'];
  String areaUnit = "Square Feet";

  //===================================ALL THE FORM CONTROLLERS
  final _propertyNameController = TextEditingController();
  final _propertyUnController = TextEditingController();
  final _propertyAreaController = TextEditingController();
  final _propertyPriceController = TextEditingController();
  final _propertyBookingAmountController = TextEditingController();
  final _propertyDescriptionController = TextEditingController();
  final _propertyAddressController = TextEditingController();
  final _propertyLocalityController = TextEditingController();
  final _propertyCityController = TextEditingController();
  final _propertyPincodeController = TextEditingController();
  final _propertyLocationUrlController = TextEditingController();

  final FocusNode _propertyNameFocusNode = FocusNode();
  final FocusNode _propertyUnFocusNode = FocusNode();
  final FocusNode _propertyAreaFocusNode = FocusNode();
  final FocusNode _propertyPriceFocusNode = FocusNode();
  final FocusNode _propertyBookingAmountFocusNode = FocusNode();
  final FocusNode _propertyDescriptionFocusNode = FocusNode();
  final FocusNode _propertyAddressFocusNode = FocusNode();
  final FocusNode _propertyLocalityFocusNode = FocusNode();
  final FocusNode _propertyCityFocusNode = FocusNode();
  final FocusNode _propertyPincodeFocusNode = FocusNode();
  final FocusNode _propertyLocationUrlFocusNode = FocusNode();

  _submitData(appState, context) async {
    var propertyData = {
      "p_name": _propertyNameController.text,
      "p_un": _propertyUnController.text,
      "p_area": _propertyAreaController.text,
      "p_areaUnit": areaUnit,
      "p_price": _propertyPriceController.text,
      "p_bookAmount": _propertyBookingAmountController.text,
      "p_type": selectedPropertyType,
      "p_bhk": selectedBhk,
      "p_floor": selectedFloor,
      "p_isGarden": selectedGarden,
      "p_isParking": selectedParking,
      "p_isFurnished": selectedFurnished,
      "p_isAvailable": selectedAvailability,
      "p_desc": _propertyDescriptionController.text,
      "p_address": _propertyAddressController.text,
      "p_locality": _propertyLocalityController.text,
      "p_city": _propertyCityController.text,
      "p_pincode": _propertyPincodeController.text,
      "p_locationUrl": _propertyLocationUrlController.text,
    };
    var url = Uri.parse(ApiLinks.insertPropertyDetails);
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
        appState.activeWidget = "PropertyListPage";
        appState.currentState = 0;
      } else {
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }
  
  @override
  void initState() {
    _mounted = true;
    final appState = Provider.of<MyProvider>(context, listen: false);
    _fetchProject(appState);
    super.initState();
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
    final dropDownCardHeight = MyConst.deviceHeight(context) * 0.06;
    final dropDownCardWidth = MyConst.deviceWidth(context) * 0.41;
    double smallBodyText = 14;
    return PopScope(
      canPop: false,
        onPopInvoked: (didPop) {
          appState.activeWidget = "ProfileWidget";
        },
        child: Container(
          color: Theme.of(context).backgroundColor,
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
                  Container(
                    width: double.infinity,
                    child: const Center(
                        child: Text(
                          'New Property Listing',
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
                            Container(
                              child: _isProjectLoading
                                  ? const Center(child:LinearProgressIndicator())
                                  : projectList.length!=0
                                  ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Under The Project',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: MyConst.smallTextSize*fontSizeScaleFactor
                                    ),
                                  ),
                                  const SizedBox(width: 20,),
                                  Card(
                                      color: Get.isDarkMode? Colors.white12:Theme.of(context).primaryColorLight,
                                      elevation: 1,
                                      child: Container(
                                        height: dropDownCardHeight*0.9,
                                        width: dropDownCardWidth,
                                        margin: const EdgeInsets.symmetric(horizontal: 8),
                                        child: DropdownButton<String>(
                                          value: selectedName.length==0 ? projectList[0]['project_name']:selectedName,
                                          alignment: Alignment.center,
                                          elevation: 16,
                                          underline: Container(),
                                          onChanged: (value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              selectedName = value!;
                                              selectedId= projectList.firstWhere((element) => element['project_name'] == value)['project_id'].toInt();
                                              print(selectedId);
                                              //print('selected property type is ${selectedPropertyType}');
                                            });
                                          },
                                          ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                                          items: projectList
                                              .map<DropdownMenuItem<String>>(
                                                  (dynamic project) {
                                                return DropdownMenuItem<String>(
                                                  value: project['project_name'],
                                                  child: Text('${project['project_name']}',
                                                      softWrap: true,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: smallBodyText,
                                                          overflow: TextOverflow
                                                              .ellipsis)),
                                                );
                                              }).toList(),
                                        ),
                                      )
                                  ),
                                ],
                              )
                                  : Container(),
                            ),
                            //===========================SPACIFICATION CONTAINER
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: MyConst.deviceWidth(context),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //==========================PROPERTY TYPE
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Select Property Type',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize:MyConst.smallTextSize*fontSizeScaleFactor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Card(
                                          color: Get.isDarkMode? Colors.white12:Theme.of(context).primaryColorLight,
                                          elevation: 1,
                                          child: Container(
                                              height: dropDownCardHeight*0.9,
                                              width: MyConst.deviceWidth(context)*0.9,
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Center(
                                                child: DropdownButton<String>(
                                                  value: selectedPropertyType,
                                                  borderRadius: BorderRadius.circular(10),
                                                  alignment: Alignment.center,
                                                  elevation: 16,
                                                  underline: Container(),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedPropertyType = value!;
                                                      //print('selected property type is ${selectedPropertyType}');
                                                    });
                                                  },
                                                  ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                                                  items: propertyType
                                                      .map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text('${value}',
                                                              softWrap: true,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: smallBodyText,
                                                                  overflow: TextOverflow
                                                                      .ellipsis)),
                                                        );
                                                      }).toList(),
                                                ),
                                              )
                                          )
                                      ),
                                    ],
                                  ),

                                  //==========================PROPERTY BHK
                                  selectedPropertyType == 'House' ||
                                      selectedPropertyType == "Flat"
                                      ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Select Property BHK',
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Card(
                                          color: Get.isDarkMode? Colors.white12:Theme.of(context).primaryColorLight,
                                          elevation: 1,
                                          child: Container(
                                              height: dropDownCardHeight*0.9,
                                              width: MyConst.deviceWidth(context)*0.9,
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Center(child: DropdownButton<String>(
                                                value: selectedBhk.toString(),
                                                elevation: 16,
                                                alignment: Alignment.center,
                                                borderRadius: BorderRadius.circular(10),
                                                underline: Container(),
                                                onChanged: (String? value) {
                                                  // This is called when the user selects an item.
                                                  setState(() {
                                                    selectedBhk = int.parse(value!);
                                                    //print('selected property type is ${selectedPropertyType}');
                                                  });
                                                },
                                                ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                                                items: bhk
                                                    .map<DropdownMenuItem<String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text('${value}',
                                                            softWrap: true,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: smallBodyText,
                                                                overflow: TextOverflow
                                                                    .ellipsis)),
                                                      );
                                                    }).toList(),
                                              ),)
                                          )
                                      ),
                                    ],
                                  )
                                      : Container(),

                                  //==========================PROPERTY FLOOR
                                  selectedPropertyType == 'House'
                                      ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Select No. Of Floors',
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Card(
                                          color: Get.isDarkMode? Colors.white12:Theme.of(context).primaryColorLight,
                                          elevation: 1,
                                          child: Container(
                                              height: dropDownCardHeight*0.9,
                                              width: MyConst.deviceWidth(context)*0.9,
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Center(
                                                child: DropdownButton<String>(
                                                  value: selectedFloor.toString(),
                                                  borderRadius: BorderRadius.circular(10),
                                                  alignment: Alignment.center,
                                                  elevation: 16,
                                                  underline: Container(),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedFloor = int.parse(value!);
                                                      //print('selected property type is ${selectedPropertyType}');
                                                    });
                                                  },
                                                  ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                                                  items: bhk
                                                      .map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text('${value}',
                                                              softWrap: true,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: smallBodyText,
                                                                  overflow: TextOverflow
                                                                      .ellipsis)),
                                                        );
                                                      }).toList(),
                                                ),
                                              )
                                          )
                                      ),
                                    ],
                                  )
                                      : Container(),

                                  //==========================isGarden facility
                                  selectedPropertyType == 'House'
                                      ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Garden Availibility',
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize:MyConst.smallTextSize*fontSizeScaleFactor
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Card(
                                          color: Get.isDarkMode? Colors.white12:Theme.of(context).primaryColorLight,
                                          elevation: 1,
                                          child: Container(
                                              height: dropDownCardHeight*0.9,
                                              width: MyConst.deviceWidth(context)*0.9,
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Center(
                                                child: DropdownButton<String>(
                                                  borderRadius: BorderRadius.circular(10),
                                                  value: selectedGarden,
                                                  alignment: Alignment.center,
                                                  elevation: 16,
                                                  underline: Container(),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedGarden = value!;
                                                      //print('selected property type is ${selectedPropertyType}');
                                                    });
                                                  },
                                                  ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                                                  items: garden
                                                      .map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text('${value}',
                                                              softWrap: true,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: smallBodyText,
                                                                  overflow: TextOverflow
                                                                      .ellipsis)),
                                                        );
                                                      }).toList(),
                                                ),
                                              )
                                          )
                                      ),
                                    ],
                                  )
                                      : Container(),

                                  //==========================isParking facility
                                  selectedPropertyType == 'House'
                                      ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:  Text(
                                          'Parking Facility',
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: MyConst.smallTextSize*fontSizeScaleFactor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Card(
                                          color: Get.isDarkMode? Colors.white12:Theme.of(context).primaryColorLight,
                                          elevation: 1,
                                          child: Container(
                                              height: dropDownCardHeight*0.9,
                                              width: MyConst.deviceWidth(context)*0.9,
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Center(
                                                child: DropdownButton<String>(
                                                  borderRadius: BorderRadius.circular(10),
                                                  value: selectedParking,
                                                  alignment: Alignment.center,
                                                  elevation: 16,
                                                  underline: Container(),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedParking = value!;
                                                      //print('selected property type is ${selectedPropertyType}');
                                                    });
                                                  },
                                                  ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                                                  items: parking
                                                      .map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text('${value}',
                                                              softWrap: true,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: smallBodyText,
                                                                  overflow: TextOverflow
                                                                      .ellipsis)),
                                                        );
                                                      }).toList(),
                                                ),
                                              )
                                          )
                                      ),
                                    ],
                                  )
                                      : Container(),

                                  //==========================isFurnished facility
                                  selectedPropertyType == 'House' ||
                                      selectedPropertyType == 'Flat'
                                      ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Furnished Or Not',
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize:MyConst.smallTextSize*fontSizeScaleFactor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Card(
                                          color: Get.isDarkMode? Colors.white12:Theme.of(context).primaryColorLight,
                                          elevation: 1,
                                          child: Container(
                                              height: dropDownCardHeight*0.9,
                                              width: MyConst.deviceWidth(context)*0.9,
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Center(
                                                child: DropdownButton<String>(
                                                  value: selectedFurnished,
                                                  borderRadius: BorderRadius.circular(10),
                                                  alignment: Alignment.center,
                                                  elevation: 16,
                                                  underline: Container(),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedFurnished = value!;
                                                      //print('selected property type is ${selectedPropertyType}');
                                                    });
                                                  },
                                                  ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                                                  items: furnished
                                                      .map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text('${value}',
                                                              softWrap: true,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: smallBodyText,
                                                                  overflow: TextOverflow
                                                                      .ellipsis)),
                                                        );
                                                      }).toList(),
                                                ),
                                              )
                                          )
                                      ),
                                    ],
                                  )
                                      : Container(),

                                  //==========================AVAILABILITY
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Available Or Not',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize:MyConst.smallTextSize*fontSizeScaleFactor
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Card(
                                          color: Get.isDarkMode? Colors.white12:Theme.of(context).primaryColorLight,
                                          elevation: 1,
                                          child: Container(
                                              height: dropDownCardHeight*0.9,
                                              width: MyConst.deviceWidth(context)*0.9,
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Center(
                                                child: DropdownButton<String>(
                                                  borderRadius: BorderRadius.circular(10),
                                                  value: selectedAvailability,
                                                  alignment: Alignment.center,
                                                  elevation: 16,
                                                  underline: Container(),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedAvailability = value!;
                                                      //print('selected property type is ${selectedPropertyType}');
                                                    });
                                                  },
                                                  ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                                                  items: available
                                                      .map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text('${value}',
                                                              softWrap: true,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: smallBodyText,
                                                                  overflow: TextOverflow
                                                                      .ellipsis)),
                                                        );
                                                      }).toList(),
                                                ),
                                              )
                                          )
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            //=============================PROPERTY NAME TEXTFIELD
                            _textField(
                                controller: _propertyNameController, 
                                focusNode: _propertyNameFocusNode, 
                                label: 'Property Name', 
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

                            //========================PROPETY UNIQUE NUMBER TEXTFIELD
                            _textField(
                                controller: _propertyUnController,
                                focusNode: _propertyUnFocusNode,
                                label: 'Property Unique Number',
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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 1,color: Colors.grey)
                              ),
                              child: Row(
                                children: [
                                  Flexible(child:
                                  //============================PROPERTY AREA
                                  _textField(
                                      controller: _propertyAreaController,
                                      focusNode: _propertyAreaFocusNode,
                                      label: 'Property Area',
                                      inputType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'please enter valid input';
                                        }
                                        return null;
                                      }
                                  ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Text('select unit:',style: TextStyle(fontSize: MyConst.smallTextSize*fontSizeScaleFactor),),

                                      Container(
                                          height: dropDownCardHeight,
                                          //width: dropDownCardWidth,
                                          child: Card(
                                              color: Get.isDarkMode? Colors.white12: Theme.of(context).primaryColorLight,
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                                child: DropdownButton<String>(
                                                  value: areaUnit,
                                                  alignment: Alignment.center,
                                                  elevation: 16,
                                                  underline: Container(),
                                                  onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      areaUnit = value!;
                                                      //print('selected property type is ${selectedPropertyType}');
                                                    });
                                                  },
                                                  ////style: TextStyle(overflow: TextOverflow.ellipsis, ),
                                                  items: areaUnits
                                                      .map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text('${value}',
                                                              softWrap: true,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: smallBodyText,
                                                                  overflow: TextOverflow
                                                                      .ellipsis)),
                                                        );
                                                      }).toList(),
                                                ),
                                              )
                                          )
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),


                            const SizedBox(
                              height: 15,
                            ),

                            //============================PROPERTY PRICE
                            _textField(
                                controller: _propertyPriceController,
                                focusNode: _propertyPriceFocusNode,
                                label: 'Property Price',
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

                            //============================PROPERTY BOOKING AMMOUNT
                            _textField(
                                controller: _propertyBookingAmountController,
                                focusNode: _propertyBookingAmountFocusNode,
                                label: 'Property Booking Amount',
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

                            //============================DESCRIPTION TEXTFIELD
                            _textField(
                                controller: _propertyDescriptionController,
                                focusNode: _propertyDescriptionFocusNode,
                                label: 'Property Description',
                                inputType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                              maxline: 4
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            //============================ADDRESS TEXTFIELD
                            _textField(
                                controller: _propertyAddressController,
                                focusNode: _propertyAddressFocusNode,
                                label: 'Property Address',
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
                                      controller: _propertyLocalityController,
                                      focusNode: _propertyLocalityFocusNode,
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
                                      controller: _propertyCityController,
                                      focusNode: _propertyCityFocusNode,
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
                                controller: _propertyPincodeController,
                                focusNode: _propertyPincodeFocusNode,
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

                            //=============================url note
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Note:',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    'please click on open map button and point you address, copy the address link and paste below',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      color: Colors.orange,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  var url =
                                      'https://maps.app.goo.gl/cC71ok8WYcdzXuGF7';
                                  StaticMethod.openMap(url);
                                },
                                child: Text('Open Map',style: TextStyle(color: bluishClr),)),

                            //============================LOCATION MAP URL TEXTFIELD
                            _textField(
                                controller: _propertyLocationUrlController,
                                focusNode: _propertyLocationUrlFocusNode,
                                label: 'Location Url',
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

                            //===============================SIGNUP BTN
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: bluishClr,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if(selectedId!=0){
                                      _submitData(appState, context);
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('please select or create a project...',style: TextStyle(color: Colors.red),)));
                                    }
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color:bluishClr
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
        validator:validator
        );
}
}

