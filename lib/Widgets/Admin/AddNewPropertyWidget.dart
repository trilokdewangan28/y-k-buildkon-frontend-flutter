import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/config/ApiLinks.dart';
import 'package:real_state/config/Constant.dart';
import 'package:real_state/config/StaticMethod.dart';

class AddNewPropertyWidget extends StatefulWidget {
  const AddNewPropertyWidget({Key? key}) : super(key: key);

  @override
  State<AddNewPropertyWidget> createState() => _AddNewPropertyWidgetState();
}

class _AddNewPropertyWidgetState extends State<AddNewPropertyWidget> {
  final _formKey = GlobalKey<FormState>();
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

  final List<String> available = ['Yes', 'No'];
  String selectedAvailability = "Yes";

  String areaUnit = "Squar Feet";

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
    final res = await StaticMethod.insertProperty(propertyData, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          '${res['message']}',
          style: const TextStyle(color: Colors.green),
        )));
        appState.activeWidget = "PropertyListWidget";
        appState.currentState = 0;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          '${res['message']}',
          style: const TextStyle(color: Colors.red),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    final dropDownCardHeight = MyConst.deviceHeight(context) * 0.06;
    final dropDownCardWidth = MyConst.deviceWidth(context) * 0.41;
    double smallBodyText = 14;
    if (selectedPropertyType == "Plot") {
      areaUnit = "Acre";
    }
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 250),
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                color: Theme.of(context).hintColor,
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
                  'New Property Listing',
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
                        //===========================SPACIFICATION CONTAINER
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              //==========================PROPERTY TYPE
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: const Text(
                                      'Select Property Type: ',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: dropDownCardHeight,
                                    width: dropDownCardWidth,
                                    child: Card(
                                      color: Theme.of(context).primaryColor,
                                      elevation: 1,
                                      child: DropdownButton<String>(
                                        value: selectedPropertyType,
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
                                              child: Expanded(
                                                child: Text('${value}',
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: smallBodyText,
                                                        overflow: TextOverflow
                                                            .ellipsis)),
                                              )
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              //==========================PROPERTY BHK
                              selectedPropertyType == 'House' ||
                                      selectedPropertyType == "Flat"
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: const Text(
                                            'Select Property BHK: ',
                                            softWrap: true,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: dropDownCardWidth,
                                          height: dropDownCardHeight,
                                          child: Card(
                                            color:
                                                Theme.of(context).primaryColor,
                                            elevation: 1,
                                            child: DropdownButton<String>(
                                              value: selectedBhk.toString(),
                                              elevation: 16,
                                              alignment: Alignment.center,
                                              underline: Container(),
                                              onChanged: (String? value) {
                                                // This is called when the user selects an item.
                                                setState(() {
                                                  selectedBhk =
                                                      int.parse(value!);
                                                  //print('selected bhk is : ${selectedBhk}');
                                                });
                                              },
                                              items: bhk.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                    child: Expanded(
                                                      child: Text('${value}',
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: smallBodyText,
                                                              overflow: TextOverflow
                                                                  .ellipsis)),
                                                    )
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(),

                              //==========================PROPERTY FLOOR
                              selectedPropertyType == 'House'
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: const Text(
                                            'Select No. Of Floors: ',
                                            softWrap: true,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: dropDownCardHeight,
                                          width: dropDownCardWidth,
                                          child: Card(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              elevation: 1,
                                              child: DropdownButton<String>(
                                                value: selectedFloor
                                                    .toString(),
                                                alignment: Alignment.center,
                                                elevation: 16,
                                                underline: Container(),
                                                onChanged: (String? value) {
                                                  // This is called when the user selects an item.
                                                  setState(() {
                                                    selectedFloor =
                                                        int.parse(value!);
                                                    //print('selected floor is : ${selectedFloor}');
                                                  });
                                                },
                                                items: floor.map<
                                                    DropdownMenuItem<
                                                        String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                          child: Expanded(
                                                            child: Text('${value}',
                                                                softWrap: true,
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: smallBodyText,
                                                                    overflow: TextOverflow
                                                                        .ellipsis)),
                                                          )
                                                      );
                                                    }).toList(),
                                              ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(),

                              //==========================isGarden facility
                              selectedPropertyType == 'House'
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: const Text(
                                            'Garden Availibility?: ',
                                            softWrap: true,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: dropDownCardHeight,
                                          width: dropDownCardWidth,
                                          child: Card(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              elevation: 1,
                                              child: DropdownButton<String>(
                                                value: selectedGarden,
                                                alignment: Alignment.center,
                                                elevation: 16,
                                                underline: Container(),
                                                onChanged:
                                                    (String? value) {
                                                  // This is called when the user selects an item.
                                                  setState(() {
                                                    selectedGarden =
                                                    value!;
                                                    //print('is Garden : ${selectedGarden}');
                                                  });
                                                },
                                                items: garden.map<
                                                    DropdownMenuItem<
                                                        String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                              fontSize: smallBodyText),
                                                        ),
                                                      );
                                                    }).toList(),
                                              ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(),

                              //==========================isParking facility
                              selectedPropertyType == 'House'
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: const Text(
                                            'Parking Facility?: ',
                                            softWrap: true,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: dropDownCardHeight,
                                          width: dropDownCardWidth,
                                          child: Card(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              elevation: 1,
                                              child: DropdownButton<String>(
                                                value: selectedParking,
                                                icon: const Icon(
                                                  Icons
                                                      .arrow_drop_down_sharp,
                                                  size: 30,
                                                ),
                                                elevation: 16,
                                                underline: Container(),
                                                onChanged:
                                                    (String? value) {
                                                  // This is called when the user selects an item.
                                                  setState(() {
                                                    selectedParking =
                                                    value!;
                                                    //print('is Parking : ${selectedParking}');
                                                  });
                                                },
                                                items: parking.map<
                                                    DropdownMenuItem<
                                                        String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                              fontSize: smallBodyText),
                                                        ),
                                                      );
                                                    }).toList(),
                                              ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(),

                              //==========================isFurnished facility
                              selectedPropertyType == 'House' ||
                                      selectedPropertyType == 'Flat'
                                  ? Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: const Text(
                                            'Furnished Or Not?: ',
                                            softWrap: true,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: dropDownCardHeight,
                                          width: dropDownCardWidth,
                                          child: Card(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              elevation: 1,
                                              child: DropdownButton<String>(
                                                value: selectedFurnished,
                                                elevation: 16,
                                                underline: Container(),
                                                alignment: Alignment.center,
                                                onChanged: (String? value) {
                                                  // This is called when the user selects an item.
                                                  setState(() {
                                                    selectedFurnished =
                                                    value!;
                                                    //print('is furnished : ${selectedFurnished}');
                                                  });
                                                },
                                                items: furnished.map<
                                                    DropdownMenuItem<
                                                        String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                              fontSize: smallBodyText),
                                                        ),
                                                      );
                                                    }).toList(),
                                              ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(),

                              //==========================AVAILABILITY
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.4,
                                    child: const Text(
                                      'Available Or Not?: ',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: dropDownCardHeight,
                                    width: dropDownCardWidth,
                                    child: Card(
                                        color: Theme.of(context).primaryColor,
                                        elevation: 1,
                                        child: DropdownButton<String>(
                                          value: selectedAvailability,
                                          elevation: 16,
                                          underline: Container(),
                                          alignment: Alignment.center,
                                          onChanged: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              selectedAvailability = value!;
                                              //print('is available : ${selectedFurnished}');
                                            });
                                          },
                                          items: available.map<
                                              DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style:
                                                    TextStyle(fontSize: smallBodyText),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        //=============================PROPERTY NAME TEXTFIELD
                        TextFormField(
                            focusNode: _propertyNameFocusNode,
                            controller: _propertyNameController,
                            decoration: const InputDecoration(
                                labelText: 'Property Name',
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
                                return 'please enter valid property name';
                              }
                              return null;
                            }),

                        const SizedBox(
                          height: 15,
                        ),

                        //========================PROPETY UNIQUE NUMBER TEXTFIELD
                        TextFormField(
                            focusNode: _propertyUnFocusNode,
                            controller: _propertyUnController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Property Unique Number',
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

                        //============================PROPERTY AREA
                        TextFormField(
                          focusNode: _propertyAreaFocusNode,
                          controller: _propertyAreaController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Property Area in $areaUnit',
                              labelStyle: const TextStyle(color: Colors.black),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  // color: Theme.of(context).hintColor
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter valid area";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        //============================PROPERTY PRICE
                        TextFormField(
                          focusNode: _propertyPriceFocusNode,
                          controller: _propertyPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Property Price',
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
                              return "please enter valid price";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        //============================PROPERTY BOOKING AMMOUNT
                        TextFormField(
                          focusNode: _propertyBookingAmountFocusNode,
                          controller: _propertyBookingAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Property Booking Ammount',
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
                              return "please enter valid booking ammount";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        //============================DESCRIPTION TEXTFIELD
                        TextFormField(
                            focusNode: _propertyDescriptionFocusNode,
                            controller: _propertyDescriptionController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                                labelText: 'Property Description',
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
                                return 'please enter valid description';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 15,
                        ),

                        //============================ADDRESS TEXTFIELD
                        TextFormField(
                            focusNode: _propertyAddressFocusNode,
                            controller: _propertyAddressController,
                            decoration: const InputDecoration(
                                labelText: 'Address',
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
                                return 'please enter valid address';
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
                                  focusNode: _propertyLocalityFocusNode,
                                  controller: _propertyLocalityController,
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
                                  focusNode: _propertyCityFocusNode,
                                  controller: _propertyCityController,
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
                            focusNode: _propertyPincodeFocusNode,
                            controller: _propertyPincodeController,
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
                            child: const Text('Open Map')),

                        //============================LOCATION MAP URL TEXTFIELD
                        TextFormField(
                            focusNode: _propertyLocationUrlFocusNode,
                            controller: _propertyLocationUrlController,
                            decoration: const InputDecoration(
                                labelText: 'Google Map Address Url',
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
                                return 'please enter valid address';
                              }
                              return null;
                            }),

                        const SizedBox(
                          height: 15,
                        ),

                        //===============================SIGNUP BTN
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _submitData(appState, context);
                              }
                            },
                            child: Text(
                              'Add Properties',
                              style:
                                  TextStyle(color: Theme.of(context).hintColor),
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

class PropertyTypeDropDown extends StatefulWidget {
  final List<String> propertyType;
  String selectedPropertyType;

  PropertyTypeDropDown(
      {super.key,
      required this.propertyType,
      required this.selectedPropertyType});

  @override
  State<PropertyTypeDropDown> createState() => _PropertyTypeDropDownState();
}

class _PropertyTypeDropDownState extends State<PropertyTypeDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      child: DropdownButton<String>(
        value: widget.selectedPropertyType,
        icon: const Icon(
          Icons.arrow_drop_down_sharp,
          size: 30,
        ),
        elevation: 16,
        underline: Container(),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            // handle the onSelect method
          });
        },
        items:
            widget.propertyType.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
